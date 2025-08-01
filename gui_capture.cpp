// gui_capture.cpp - Capturador avanzado de GUI con extracción de texto
// Compilar: g++ -o gui_capture.exe gui_capture.cpp -lgdi32 -luser32 -lole32 -loleaut32 -lpsapi

#include <windows.h>
#include <psapi.h>
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include "security_config.h"

using namespace std;

class GUICapture {
private:
    struct WindowData {
        HWND hwnd;
        string title;
        string processName;
        DWORD pid;
        RECT rect;
        bool visible;
    };

    vector<WindowData> windows;

    string GetWindowTitle(HWND hwnd) {
        char title[256];
        GetWindowTextA(hwnd, title, sizeof(title));
        return string(title);
    }

    string GetProcessName(DWORD pid) {
        HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid);
        if (hProcess == NULL) return "";

        char name[MAX_PATH];
        GetModuleBaseNameA(hProcess, NULL, name, MAX_PATH);
        CloseHandle(hProcess);
        return string(name);
    }

    bool CaptureWindow(HWND hwnd, const string& filename) {
        HDC hdcWindow = GetDC(hwnd);
        HDC hdcMemory = CreateCompatibleDC(hdcWindow);

        RECT rect;
        GetClientRect(hwnd, &rect);
        int width = rect.right - rect.left;
        int height = rect.bottom - rect.top;

        HBITMAP hBitmap = CreateCompatibleBitmap(hdcWindow, width, height);
        HBITMAP hOldBitmap = (HBITMAP)SelectObject(hdcMemory, hBitmap);

        BitBlt(hdcMemory, 0, 0, width, height, hdcWindow, 0, 0, SRCCOPY);

        // Guardar como BMP
        BITMAPINFOHEADER bi;
        bi.biSize = sizeof(BITMAPINFOHEADER);
        bi.biWidth = width;
        bi.biHeight = height;
        bi.biPlanes = 1;
        bi.biBitCount = 24;
        bi.biCompression = BI_RGB;
        bi.biSizeImage = 0;
        bi.biXPelsPerMeter = 0;
        bi.biYPelsPerMeter = 0;
        bi.biClrUsed = 0;
        bi.biClrImportant = 0;

        vector<BYTE> buffer(width * height * 3);
        GetDIBits(hdcMemory, hBitmap, 0, height, buffer.data(), (BITMAPINFO*)&bi, DIB_RGB_COLORS);

        ofstream file(filename, ios::binary);
        if (!file.is_open()) return false;

        // Header BMP
        BITMAPFILEHEADER bfh;
        bfh.bfType = 0x4D42;
        bfh.bfSize = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER) + buffer.size();
        bfh.bfReserved1 = 0;
        bfh.bfReserved2 = 0;
        bfh.bfOffBits = sizeof(BITMAPFILEHEADER) + sizeof(BITMAPINFOHEADER);

        file.write((char*)&bfh, sizeof(BITMAPFILEHEADER));
        file.write((char*)&bi, sizeof(BITMAPINFOHEADER));
        file.write((char*)buffer.data(), buffer.size());

        SelectObject(hdcMemory, hOldBitmap);
        DeleteObject(hBitmap);
        DeleteDC(hdcMemory);
        ReleaseDC(hwnd, hdcWindow);

        return true;
    }

    string ExtractTextFromWindow(HWND hwnd) {
        // Intentar obtener texto usando WM_GETTEXT
        char text[1024];
        GetWindowTextA(hwnd, text, sizeof(text));
        string result = string(text);

        // Buscar controles hijos con texto
        EnumChildWindows(hwnd, [](HWND child, LPARAM lParam) -> BOOL {
            char childText[256];
            GetWindowTextA(child, childText, sizeof(childText));
            if (strlen(childText) > 0) {
                string* result = (string*)lParam;
                *result += " | " + string(childText);
            }
            return TRUE;
        }, (LPARAM)&result);

        return result;
    }

public:
    void ScanWindows() {
        windows.clear();
        EnumWindows([](HWND hwnd, LPARAM lParam) -> BOOL {
            GUICapture* self = (GUICapture*)lParam;

            if (IsWindowVisible(hwnd)) {
                WindowData data;
                data.hwnd = hwnd;
                data.title = self->GetWindowTitle(hwnd);
                data.visible = IsWindowVisible(hwnd);
                GetWindowRect(hwnd, &data.rect);

                DWORD pid;
                GetWindowThreadProcessId(hwnd, &pid);
                data.pid = pid;
                data.processName = self->GetProcessName(pid);

                if (data.title.length() > 0) {
                    self->windows.push_back(data);
                }
            }
            return TRUE;
        }, (LPARAM)this);
    }

    void ListWindows() {
        cout << "=== VENTANAS DETECTADAS (SOLO NAVEGADORES) ===" << endl;
        cout << "PID\tProceso\t\tTitulo\t\t\tPosicion\tTamaño" << endl;
        cout << "---\t-------\t\t-----\t\t\t--------\t------" << endl;

        for (const auto& win : windows) {
            if (SecurityConfig::IsProcessAllowed(win.processName)) {
                cout << win.pid << "\t";
                cout << win.processName.substr(0, 12) << "\t";
                cout << win.title.substr(0, 20) << "\t";
                cout << "(" << win.rect.left << "," << win.rect.top << ") ";
                cout << "(" << win.rect.right << "," << win.rect.bottom << ")\t";
                cout << (win.rect.right - win.rect.left) << "x" << (win.rect.bottom - win.rect.top);
                cout << endl;
            }
        }
    }

    void CaptureSpecificWindow(const string& processName) {
        cout << "=== CAPTURANDO VENTANAS DE: " << processName << " ===" << endl;

        for (const auto& win : windows) {
            if (win.processName.find(processName) != string::npos) {
                string filename = "capture_" + win.processName + "_" + to_string(win.pid) + ".bmp";

                cout << "Capturando: " << win.title << endl;
                if (CaptureWindow(win.hwnd, filename)) {
                    cout << "  Guardado como: " << filename << endl;

                    string text = ExtractTextFromWindow(win.hwnd);
                    if (text.length() > 0) {
                        cout << "  Texto detectado: " << text.substr(0, 100) << endl;
                    }
                } else {
                    cout << "  Error al capturar" << endl;
                }
                cout << "---" << endl;
            }
        }
    }

    void MonitorActiveWindow() {
        HWND activeWindow = GetForegroundWindow();
        if (activeWindow == NULL) {
            cout << "No hay ventana activa" << endl;
            return;
        }

        char title[256];
        GetWindowTextA(activeWindow, title, sizeof(title));

        DWORD pid;
        GetWindowThreadProcessId(activeWindow, &pid);
        string processName = GetProcessName(pid);

        RECT rect;
        GetWindowRect(activeWindow, &rect);

        cout << "=== VENTANA ACTIVA ===" << endl;
        cout << "Proceso: " << processName << endl;
        cout << "PID: " << pid << endl;
        cout << "Titulo: " << title << endl;
        cout << "Posicion: (" << rect.left << "," << rect.top << ")" << endl;
        cout << "Tamaño: " << (rect.right - rect.left) << "x" << (rect.bottom - rect.top) << endl;

        // Verificar si es un proceso permitido
        if (!SecurityConfig::IsProcessAllowed(processName)) {
            cout << "ADVERTENCIA: Proceso no está en la lista blanca." << endl;
            cout << "Procesos permitidos:" << endl;
            for (const auto& proc : SecurityConfig::GetAllowedProcesses()) {
                cout << "  - " << proc << endl;
            }
            return;
        }

        string text = ExtractTextFromWindow(activeWindow);
        if (text.length() > 0) {
            cout << "Texto: " << text << endl;
        }
    }
};

int main(int argc, char* argv[]) {
    // Inicializar configuración de seguridad
    SecurityConfig::Initialize();

    // Verificar permisos de administrador
    if (!SecurityConfig::ValidateAccess()) {
        cout << "ERROR: Se requieren permisos de administrador para ejecutar este programa." << endl;
        cout << "Ejecuta como administrador o deshabilita la seguridad." << endl;
        return 1;
    }

    GUICapture capture;

    if (argc < 2) {
        cout << "Uso: gui_capture.exe [opcion] [proceso]" << endl;
        cout << "Opciones:" << endl;
        cout << "  list - Listar ventanas (solo navegadores)" << endl;
        cout << "  capture [proceso] - Capturar ventanas de proceso" << endl;
        cout << "  active - Monitorear ventana activa" << endl;
        cout << "  security - Mostrar configuración de seguridad" << endl;
        return 1;
    }

    string option = argv[1];
    string processName = (argc > 2) ? argv[2] : "";

    capture.ScanWindows();

    if (option == "list") {
        capture.ListWindows();
    } else if (option == "capture" && !processName.empty()) {
        // Verificar si el proceso está permitido
        if (!SecurityConfig::IsProcessAllowed(processName)) {
            cout << "ERROR: Proceso '" << processName << "' no está en la lista blanca." << endl;
            cout << "Procesos permitidos:" << endl;
            for (const auto& proc : SecurityConfig::GetAllowedProcesses()) {
                cout << "  - " << proc << endl;
            }
            return 1;
        }
        capture.CaptureSpecificWindow(processName);
    } else if (option == "active") {
        capture.MonitorActiveWindow();
    } else if (option == "security") {
        cout << "=== CONFIGURACIÓN DE SEGURIDAD ===" << endl;
        cout << "Seguridad habilitada: " << (SecurityConfig::IsSecurityEnabled() ? "Si" : "No") << endl;
        cout << "Procesos permitidos:" << endl;
        for (const auto& proc : SecurityConfig::GetAllowedProcesses()) {
            cout << "  - " << proc << endl;
        }
    } else {
        cout << "Opción inválida" << endl;
        return 1;
    }

    return 0;
}

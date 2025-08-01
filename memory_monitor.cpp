// memory_monitor.cpp - Capturador avanzado de GUI y texto
// Compilar: g++ -o memory_monitor.exe memory_monitor.cpp -lgdi32 -luser32

#include <windows.h>
#include <iostream>
#include <string>
#include <vector>
#include <psapi.h>
#include <tlhelp32.h>
#include <sstream>
#include "security_config.h"

using namespace std;

struct ProcessInfo {
    DWORD pid;
    string name;
    string title;
    SIZE_T memory;
    bool visible;
    RECT rect;
};

class MemoryMonitor {
private:
    vector<ProcessInfo> processes;

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

    SIZE_T GetProcessMemory(DWORD pid) {
        HANDLE hProcess = OpenProcess(PROCESS_QUERY_INFORMATION | PROCESS_VM_READ, FALSE, pid);
        if (hProcess == NULL) return 0;

        PROCESS_MEMORY_COUNTERS pmc;
        if (GetProcessMemoryInfo(hProcess, &pmc, sizeof(pmc))) {
            CloseHandle(hProcess);
            return pmc.WorkingSetSize;
        }
        CloseHandle(hProcess);
        return 0;
    }

public:
    void ScanProcesses() {
        processes.clear();
        HANDLE hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
        if (hSnapshot == INVALID_HANDLE_VALUE) return;

        PROCESSENTRY32 pe32;
        pe32.dwSize = sizeof(PROCESSENTRY32);

        if (Process32First(hSnapshot, &pe32)) {
            do {
                ProcessInfo info;
                info.pid = pe32.th32ProcessID;
                info.name = string(pe32.szExeFile);
                info.memory = GetProcessMemory(pe32.th32ProcessID);

                // Buscar ventana principal
                HWND hwnd = FindWindow(NULL, NULL);
                while (hwnd != NULL) {
                    DWORD windowPid;
                    GetWindowThreadProcessId(hwnd, &windowPid);

                    if (windowPid == pe32.th32ProcessID) {
                        info.title = GetWindowTitle(hwnd);
                        info.visible = IsWindowVisible(hwnd);
                        GetWindowRect(hwnd, &info.rect);
                        break;
                    }
                    hwnd = GetWindow(hwnd, GW_HWNDNEXT);
                }

                if (info.memory > 0) {
                    processes.push_back(info);
                }
            } while (Process32Next(hSnapshot, &pe32));
        }
        CloseHandle(hSnapshot);
    }

    void PrintMemoryUsage() {
        cout << "=== USO DE MEMORIA POR PROCESO (SOLO NAVEGADORES) ===" << endl;
        cout << "PID\tMemoria(MB)\tProceso\t\tTitulo" << endl;
        cout << "---\t----------\t-------\t\t------" << endl;

        for (const auto& proc : processes) {
            if (proc.memory > 1024 * 1024 && SecurityConfig::IsProcessAllowed(proc.name)) {
                cout << proc.pid << "\t";
                cout << (proc.memory / (1024 * 1024)) << " MB\t";
                cout << proc.name.substr(0, 12) << "\t";
                if (proc.title.length() > 0) {
                    cout << proc.title.substr(0, 30);
                }
                cout << endl;
            }
        }
    }

    void PrintWindowInfo() {
        cout << "=== VENTANAS ACTIVAS (SOLO NAVEGADORES) ===" << endl;
        cout << "PID\tProceso\t\tTitulo\t\t\tPosicion\tTamaño" << endl;
        cout << "---\t-------\t\t-----\t\t\t--------\t------" << endl;

        for (const auto& proc : processes) {
            if (proc.title.length() > 0 && proc.visible && SecurityConfig::IsProcessAllowed(proc.name)) {
                cout << proc.pid << "\t";
                cout << proc.name.substr(0, 12) << "\t";
                cout << proc.title.substr(0, 20) << "\t";
                cout << "(" << proc.rect.left << "," << proc.rect.top << ") ";
                cout << "(" << proc.rect.right << "," << proc.rect.bottom << ")\t";
                cout << (proc.rect.right - proc.rect.left) << "x" << (proc.rect.bottom - proc.rect.top);
                cout << endl;
            }
        }
    }

    void MonitorSpecificProcess(const string& processName) {
        cout << "=== MONITOREO: " << processName << " ===" << endl;

        for (const auto& proc : processes) {
            if (proc.name.find(processName) != string::npos) {
                cout << "PID: " << proc.pid << endl;
                cout << "Memoria: " << (proc.memory / (1024 * 1024)) << " MB" << endl;
                cout << "Titulo: " << proc.title << endl;
                cout << "Visible: " << (proc.visible ? "Si" : "No") << endl;
                if (proc.visible) {
                    cout << "Posicion: (" << proc.rect.left << "," << proc.rect.top << ")" << endl;
                    cout << "Tamaño: " << (proc.rect.right - proc.rect.left) << "x" << (proc.rect.bottom - proc.rect.top) << endl;
                }
                cout << "---" << endl;
            }
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

    MemoryMonitor monitor;

    if (argc < 2) {
        cout << "Uso: memory_monitor.exe [opcion] [proceso]" << endl;
        cout << "Opciones:" << endl;
        cout << "  memory - Mostrar uso de memoria (solo navegadores)" << endl;
        cout << "  gui - Mostrar ventanas activas (solo navegadores)" << endl;
        cout << "  monitor [proceso] - Monitorear proceso específico" << endl;
        cout << "  security - Mostrar configuración de seguridad" << endl;
        cout << "  allow [proceso] - Agregar proceso a lista blanca" << endl;
        cout << "  deny [proceso] - Remover proceso de lista blanca" << endl;
        return 1;
    }

    string option = argv[1];
    string processName = (argc > 2) ? argv[2] : "";

    monitor.ScanProcesses();

    if (option == "memory") {
        monitor.PrintMemoryUsage();
    } else if (option == "gui") {
        monitor.PrintWindowInfo();
    } else if (option == "monitor" && !processName.empty()) {
        // Verificar si el proceso está permitido
        if (!SecurityConfig::IsProcessAllowed(processName)) {
            cout << "ERROR: Proceso '" << processName << "' no está en la lista blanca." << endl;
            cout << "Procesos permitidos:" << endl;
            for (const auto& proc : SecurityConfig::GetAllowedProcesses()) {
                cout << "  - " << proc << endl;
            }
            return 1;
        }
        monitor.MonitorSpecificProcess(processName);
    } else if (option == "security") {
        cout << "=== CONFIGURACIÓN DE SEGURIDAD ===" << endl;
        cout << "Seguridad habilitada: " << (SecurityConfig::IsSecurityEnabled() ? "Si" : "No") << endl;
        cout << "Procesos permitidos:" << endl;
        for (const auto& proc : SecurityConfig::GetAllowedProcesses()) {
            cout << "  - " << proc << endl;
        }
    } else if (option == "allow" && !processName.empty()) {
        SecurityConfig::AddAllowedProcess(processName);
        cout << "Proceso '" << processName << "' agregado a la lista blanca." << endl;
    } else if (option == "deny" && !processName.empty()) {
        SecurityConfig::RemoveAllowedProcess(processName);
        cout << "Proceso '" << processName << "' removido de la lista blanca." << endl;
    } else {
        cout << "Opción inválida" << endl;
        return 1;
    }

    return 0;
}

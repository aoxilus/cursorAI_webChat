// chatgpt_automation.cpp - Motor de automatización para ChatGPT
// Compilar: g++ -o chatgpt_automation.exe chatgpt_automation.cpp -lgdi32 -luser32 -lole32 -loleaut32 -lpsapi

#include <windows.h>
#include <iostream>
#include <string>
#include <vector>
#include <fstream>
#include <sstream>
#include <thread>
#include <chrono>

using namespace std;

class ChatGPTAutomation {
private:
    HWND chatgptWindow;
    HWND inputBox;
    HWND sendButton;
    HWND responseArea;

    bool FindChatGPTWindow() {
        chatgptWindow = FindWindow(NULL, NULL);
        while (chatgptWindow != NULL) {
            char title[256];
            GetWindowTextA(chatgptWindow, title, sizeof(title));
            string titleStr(title);

            if (titleStr.find("ChatGPT") != string::npos &&
                titleStr.find("Google Chrome") != string::npos) {
                return true;
            }
            chatgptWindow = GetWindow(chatgptWindow, GW_HWNDNEXT);
        }
        return false;
    }

    bool FindInputElements() {
        if (chatgptWindow == NULL) return false;

        // Buscar el área de texto de entrada
        inputBox = FindWindowEx(chatgptWindow, NULL, "TEXTAREA", NULL);
        if (inputBox == NULL) {
            inputBox = FindWindowEx(chatgptWindow, NULL, "EDIT", NULL);
        }

        // Buscar botón de envío
        sendButton = FindWindowEx(chatgptWindow, NULL, "BUTTON", NULL);

        return (inputBox != NULL);
    }

    void SendTextToInput(const string& text) {
        if (inputBox == NULL) return;

        // Limpiar texto existente
        SendMessageA(inputBox, WM_SETTEXT, 0, (LPARAM)"");

        // Enviar texto carácter por carácter
        for (char c : text) {
            SendMessageA(inputBox, WM_CHAR, c, 0);
            Sleep(10);
        }
    }

    void ClickSendButton() {
        if (sendButton == NULL) return;

        // Simular clic en el botón
        SendMessageA(sendButton, BM_CLICK, 0, 0);

        // Alternativa: usar Enter
        SendMessageA(inputBox, WM_KEYDOWN, VK_RETURN, 0);
        SendMessageA(inputBox, WM_KEYUP, VK_RETURN, 0);
    }

    string GetResponseText() {
        if (chatgptWindow == NULL) return "";

        // Buscar área de respuesta
        HWND responseWindow = FindWindowEx(chatgptWindow, NULL, "DIV", NULL);
        if (responseWindow == NULL) return "";

        char text[4096];
        GetWindowTextA(responseWindow, text, sizeof(text));
        return string(text);
    }

public:
    bool Initialize() {
        cout << "Buscando ventana de ChatGPT..." << endl;
        if (!FindChatGPTWindow()) {
            cout << "ERROR: No se encontró ventana de ChatGPT" << endl;
            return false;
        }

        cout << "ChatGPT encontrado. Buscando elementos de interfaz..." << endl;
        if (!FindInputElements()) {
            cout << "ERROR: No se encontraron elementos de entrada" << endl;
            return false;
        }

        cout << "ChatGPT listo para automatización" << endl;
        return true;
    }

    bool SendPrompt(const string& prompt) {
        cout << "Enviando prompt: " << prompt.substr(0, 50) << "..." << endl;

        SendTextToInput(prompt);
        Sleep(100);
        ClickSendButton();

        cout << "Prompt enviado. Esperando respuesta..." << endl;
        return true;
    }

    string WaitForResponse(int timeoutSeconds = 30) {
        auto start = chrono::steady_clock::now();
        string lastResponse = "";

        while (chrono::duration_cast<chrono::seconds>(
               chrono::steady_clock::now() - start).count() < timeoutSeconds) {

            string currentResponse = GetResponseText();
            if (currentResponse != lastResponse && currentResponse.length() > 0) {
                cout << "Respuesta recibida: " << currentResponse.substr(0, 100) << "..." << endl;
                return currentResponse;
            }

            Sleep(1000);
        }

        cout << "Timeout esperando respuesta" << endl;
        return "";
    }

    bool GenerateCode(const string& language, const string& description) {
        string prompt = "Genera código en " + language + " para: " + description +
                       "\n\nPor favor proporciona solo el código sin explicaciones adicionales.";

        if (!SendPrompt(prompt)) return false;

        string response = WaitForResponse();
        if (response.empty()) return false;

        // Guardar código en archivo
        string filename = "generated_code." + language;
        ofstream file(filename);
        if (file.is_open()) {
            file << response;
            file.close();
            cout << "Código guardado en: " << filename << endl;
        }

        return true;
    }

    bool AskQuestion(const string& question) {
        if (!SendPrompt(question)) return false;

        string response = WaitForResponse();
        if (response.empty()) return false;

        cout << "Respuesta completa:" << endl;
        cout << response << endl;
        return true;
    }

    void StartInteractiveMode() {
        cout << "=== MODO INTERACTIVO CHATGPT ===" << endl;
        cout << "Comandos disponibles:" << endl;
        cout << "  /code [lenguaje] [descripción] - Generar código" << endl;
        cout << "  /ask [pregunta] - Hacer pregunta" << endl;
        cout << "  /exit - Salir" << endl;
        cout << "  [texto] - Enviar mensaje normal" << endl;
        cout << endl;

        string input;
        while (true) {
            cout << "ChatGPT> ";
            getline(cin, input);

            if (input == "/exit") break;

            if (input.substr(0, 5) == "/code") {
                size_t pos = input.find(" ", 6);
                if (pos != string::npos) {
                    string language = input.substr(6, pos - 6);
                    string description = input.substr(pos + 1);
                    GenerateCode(language, description);
                }
            } else if (input.substr(0, 4) == "/ask") {
                string question = input.substr(5);
                AskQuestion(question);
            } else {
                AskQuestion(input);
            }
        }
    }
};

int main(int argc, char* argv[]) {
    ChatGPTAutomation chatgpt;

    if (!chatgpt.Initialize()) {
        cout << "Error inicializando ChatGPT. Asegúrate de tener ChatGPT abierto en Chrome." << endl;
        return 1;
    }

    if (argc < 2) {
        chatgpt.StartInteractiveMode();
        return 0;
    }

    string command = argv[1];

    if (command == "code" && argc >= 4) {
        string language = argv[2];
        string description = argv[3];
        chatgpt.GenerateCode(language, description);
    } else if (command == "ask" && argc >= 3) {
        string question = argv[2];
        chatgpt.AskQuestion(question);
    } else if (command == "interactive") {
        chatgpt.StartInteractiveMode();
    } else {
        cout << "Uso: chatgpt_automation.exe [comando] [parámetros]" << endl;
        cout << "Comandos:" << endl;
        cout << "  code [lenguaje] [descripción] - Generar código" << endl;
        cout << "  ask [pregunta] - Hacer pregunta" << endl;
        cout << "  interactive - Modo interactivo" << endl;
        cout << endl;
        cout << "Ejemplos:" << endl;
        cout << "  chatgpt_automation.exe code python \"función para ordenar lista\"" << endl;
        cout << "  chatgpt_automation.exe ask \"¿Qué es Python?\"" << endl;
        cout << "  chatgpt_automation.exe interactive" << endl;
    }

    return 0;
}

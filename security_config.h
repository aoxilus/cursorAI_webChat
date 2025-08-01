// security_config.h - Configuración de seguridad para monitoreo
#ifndef SECURITY_CONFIG_H
#define SECURITY_CONFIG_H

#include <string>
#include <vector>
#include <windows.h>

class SecurityConfig {
private:
    static std::vector<std::string> allowedProcesses;
    static std::vector<std::string> allowedDomains;
    static bool securityEnabled;

public:
    static void Initialize() {
        // Solo navegadores y aplicaciones web seguras
        allowedProcesses = {
            "chrome.exe",
            "msedge.exe",
            "firefox.exe",
            "opera.exe",
            "brave.exe",
            "safari.exe",
            "iexplore.exe"
        };

        // Dominios permitidos (opcional)
        allowedDomains = {
            "google.com",
            "youtube.com",
            "github.com",
            "stackoverflow.com",
            "microsoft.com"
        };

        securityEnabled = true;
    }

    static bool IsProcessAllowed(const std::string& processName) {
        if (!securityEnabled) return true;

        for (const auto& allowed : allowedProcesses) {
            if (processName.find(allowed) != std::string::npos) {
                return true;
            }
        }
        return false;
    }

    static bool IsDomainAllowed(const std::string& domain) {
        if (!securityEnabled) return true;

        for (const auto& allowed : allowedDomains) {
            if (domain.find(allowed) != std::string::npos) {
                return true;
            }
        }
        return false;
    }

    static void EnableSecurity(bool enable) {
        securityEnabled = enable;
    }

    static bool IsSecurityEnabled() {
        return securityEnabled;
    }

    static std::vector<std::string> GetAllowedProcesses() {
        return allowedProcesses;
    }

    static void AddAllowedProcess(const std::string& processName) {
        allowedProcesses.push_back(processName);
    }

    static void RemoveAllowedProcess(const std::string& processName) {
        for (auto it = allowedProcesses.begin(); it != allowedProcesses.end(); ++it) {
            if (*it == processName) {
                allowedProcesses.erase(it);
                break;
            }
        }
    }

    static bool IsAdminUser() {
        BOOL isAdmin = FALSE;
        PSID adminGroup = NULL;
        SID_IDENTIFIER_AUTHORITY ntAuthority = SECURITY_NT_AUTHORITY;

        if (AllocateAndInitializeSid(&ntAuthority, 2, SECURITY_BUILTIN_DOMAIN_RID,
            DOMAIN_ALIAS_RID_ADMINS, 0, 0, 0, 0, 0, 0, &adminGroup)) {
            CheckTokenMembership(NULL, adminGroup, &isAdmin);
            FreeSid(adminGroup);
        }

        return isAdmin == TRUE;
    }

    static bool ValidateAccess() {
        // Para pruebas, permitir acceso sin admin
        // En producción, cambiar a: return IsAdminUser();
        return true;
    }
};

// Inicializar variables estáticas
std::vector<std::string> SecurityConfig::allowedProcesses;
std::vector<std::string> SecurityConfig::allowedDomains;
bool SecurityConfig::securityEnabled = true;

#endif

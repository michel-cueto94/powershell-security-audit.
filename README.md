Windows Server Security Audit Script

Script en PowerShell diseñado para automatizar el diagnóstico rápido de postura de seguridad y hardening en sistemas Windows Server y Workstations.

---

🚀 Características del Script

* **Auditoría de Red:** Identificación rápida de direccionamiento IPv4.
* **Control de Firewall:** Verificación del estado de los perfiles Domain, Private y Public.
* **Directivas de Cuenta:** Comprobación del umbral de bloqueo de cuenta (*Account Lockout Threshold*).
* **Análisis de Logs (SIEM Local):** Detección de intentos fallidos de inicio de sesión (Event ID 4625).
* **Privilegios Elevados:** Enumeración de miembros en el grupo local de Administradores.

--

 Modo de Uso

1. Abrir PowerShell como **Administrador**.
2. Habilitar la ejecución temporal de scripts (si es necesario):
   ```powershell
   Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process


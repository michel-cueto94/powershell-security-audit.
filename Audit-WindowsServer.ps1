<#
.SYNOPSIS
    Script de Auditoría de Seguridad Básica para Windows / Windows Server
.AUTHOR
    Tec. Michel Cueto
.DESCRIPTION
    Revisa el estado del Firewall, Políticas de Bloqueo, Eventos 4625 y Usuarios Administradores.
#>

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "   AUDITORÍA DE SEGURIDAD - LOCAL HOST    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. Información de Red
Write-Host "[+] Evaluando configuración de red..." -ForegroundColor Yellow
$IP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.InterfaceAlias -notlike "*Loopback*"}).IPAddress
Write-Host "    -> Dirección IP detectada: $IP" -ForegroundColor White

# 2. Estado del Firewall
Write-Host "`n[+] Verificando perfiles del Firewall de Windows..." -ForegroundColor Yellow
$FW = Get-NetFirewallProfile | Select-Object Name, Enabled
foreach ($profile in $FW) {
    $status = if ($profile.Enabled) { "HABILITADO" } else { "DESHABILITADO (¡Riesgo!)" }
    Write-Host "    -> Perfil $($profile.Name): $status" -ForegroundColor White
}

# 3. Política de Bloqueo de Cuentas
Write-Host "`n[+] Verificando directivas de bloqueo de cuenta..." -ForegroundColor Yellow
$Lockout = net accounts | Select-String "Threshold|Umbral"
Write-Host "    -> $Lockout" -ForegroundColor White

# 4. Auditoría de Eventos ID 4625 (Últimos 3)
Write-Host "`n[+] Auditando intentos fallidos de inicio de sesión (Event ID 4625)..." -ForegroundColor Yellow
$FailedLogs = Get-WinEvent -FilterHashtable @{LogName='Security'; Id=4625} -ErrorAction SilentlyContinue | Select-Object -First 3
if ($FailedLogs) {
    foreach ($log in $FailedLogs) {
        Write-Host "    [!] Alerta: Fallo registrado el $($log.TimeCreated)" -ForegroundColor Red
    }
} else {
    Write-Host "    -> Sin eventos 4625 recientes encontrados." -ForegroundColor Green
}

# 5. Usuarios Administradores Locales
Write-Host "`n[+] Usuarios en el grupo Administradores:" -ForegroundColor Yellow
Get-LocalGroupMember -Group "Administradores" -ErrorAction SilentlyContinue | ForEach-Object {
    Write-Host "    -> User: $($_.Name)" -ForegroundColor White
}

Write-Host "`n==========================================" -ForegroundColor Cyan
Write-Host "       FIN DE LA AUDITORÍA DE SEGURIDAD    " -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

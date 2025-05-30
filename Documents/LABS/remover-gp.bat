@echo off
echo ==========================================================================
echo =           Script para Remocao do GlobalProtect                      =
echo ==========================================================================
echo.
echo ATENCAO: Este script deve ser executado como ADMINISTRADOR.
echo Pressione qualquer tecla para continuar ou CTRL+C para cancelar.
pause > nul

echo.
echo == Parando servicos e processos do GlobalProtect ==
taskkill /im pangpa.exe /f /t > nul 2>&1
taskkill /im PanGPS.exe /f /t > nul 2>&1
taskkill /im GpHNAgent.exe /f /t > nul 2>&1
taskkill /im GpHipMonitor.exe /f /t > nul 2>&1

net stop PanGPS /y > nul 2>&1
sc delete PanGPS > nul 2>&1
net stop PanGpHip /y > nul 2>&1
sc delete PanGpHip > nul 2>&1

echo.
echo == Tentando desinstalar o GlobalProtect via WMIC ==
echo Por favor, aguarde. Isso pode levar alguns minutos...
wmic product where "name like 'GlobalProtect%'" call uninstall /nointeractive
wmic product where "description like 'GlobalProtect%'" call uninstall /nointeractive

echo.
echo == Removendo pastas residuais do GlobalProtect ==
echo Removendo diretorio de instalacao...
if exist "%ProgramFiles%\Palo Alto Networks\GlobalProtect" (
    rd /s /q "%ProgramFiles%\Palo Alto Networks\GlobalProtect"
    echo Removido: "%ProgramFiles%\Palo Alto Networks\GlobalProtect"
) else if exist "%ProgramFiles(x86)%\Palo Alto Networks\GlobalProtect" (
    rd /s /q "%ProgramFiles(x86)%\Palo Alto Networks\GlobalProtect"
    echo Removido: "%ProgramFiles(x86)%\Palo Alto Networks\GlobalProtect"
) else (
    echo Diretorio de instalacao do GlobalProtect nao encontrado em locais padrao.
)

echo Removendo pastas de dados do aplicativo...
if exist "%LOCALAPPDATA%\Palo Alto Networks\GlobalProtect" (
    rd /s /q "%LOCALAPPDATA%\Palo Alto Networks\GlobalProtect"
    echo Removido: "%LOCALAPPDATA%\Palo Alto Networks\GlobalProtect"
) else (
    echo Pasta de dados do GlobalProtect em AppData\Local nao encontrada.
)

if exist "%ProgramData%\Palo Alto Networks\GlobalProtect" (
    rd /s /q "%ProgramData%\Palo Alto Networks\GlobalProtect"
    echo Removido: "%ProgramData%\Palo Alto Networks\GlobalProtect"
) else (
    echo Pasta de dados do GlobalProtect em ProgramData nao encontrada.
)

echo.
echo == Removendo chaves de registro residuais do GlobalProtect ==
reg delete "HKLM\SOFTWARE\Palo Alto Networks\GlobalProtect" /f > nul 2>&1
reg delete "HKLM\SOFTWARE\WOW6432Node\Palo Alto Networks\GlobalProtect" /f > nul 2>&1
reg delete "HKCU\Software\Palo Alto Networks\GlobalProtect" /f > nul 2>&1

reg delete "HKLM\SYSTEM\CurrentControlSet\Services\PanGPS" /f > nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\PanGpHip" /f > nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\PanNetDrv" /f > nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\pangpd" /f > nul 2>&1
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\EventLog\Application\PanGPS" /f > nul 2>&1

echo.
echo == Verificando adaptadores de rede GlobalProtect (informativo) ==
echo (Pode ser necessario remover manualmente via Gerenciador de Dispositivos se persistirem)
powershell -Command "Get-NetAdapter -Name '*' | Where-Object {$_.InterfaceDescription -like 'Palo Alto Networks GlobalProtect*'}"

echo.
echo ==========================================================================
echo = Processo de remocao do GlobalProtect concluido.                    =
echo ==========================================================================
echo.
echo E ALTAMENTE RECOMENDADO reiniciar o computador para concluir a remocao.
echo Se desejar reiniciar agora, descomente a linha 'shutdown' no final do script.
REM shutdown /r /t 0 /c "Reiniciando para concluir a desinstalacao do GlobalProtect"

echo Pressione qualquer tecla para sair.
pause > nul
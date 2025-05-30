@echo off
SETLOCAL ENABLEDELAYEDEXPANSION

REM --- Configurações (AJUSTE ESTES VALORES!) ---
SET "NetskopeInstallerName=NSClient.msi"
SET "InstallerPath=C:\Caminho\Para\O\Instalador"
SET "InstallLogFile=C:\Temp\Netskope_Install_Log.txt"
SET "UninstallLogFile=C:\Temp\Netskope_Uninstall_Log.txt"
REM Adicione aqui quaisquer outros parâmetros de instalação necessários, ex:
REM SET "INSTALL_OPTIONS=/qn TENANT_ID=seu_tenant_id ADDLOCAL=ALL"
SET "INSTALL_OPTIONS=/qn" REM Exemplo básico para instalação silenciosa .msi

REM --- Nome do Produto (Pode variar - Verifique em "Programas e Recursos") ---
SET "NetskopeProductName=Netskope Client"
REM Outras possibilidades: "Netskope" ou similar. Use wmic para descobrir.

REM --- Caminho para o executável de desinstalação (se necessário) ---
REM Geralmente não é necessário para desinstalação via WMIC ou MSIEXEC

REM --- Verificação de Privilégios Administrativos ---
echo Verificando privilegios de administrador...
net session >nul 2>&1
if %errorLevel% == 0 (
    echo Privilegios de administrador confirmados.
) else (
    echo ERRO: Este script precisa ser executado como Administrador.
    pause
    exit /b 1
)

echo.
echo Iniciando processo de desinstalacao e reinstalacao do Netskope Client...
echo ATENCAO: Isso interrompera temporariamente a conectividade do Netskope.
echo Pressione qualquer tecla para continuar ou CTRL+C para cancelar.
pause >nul
echo.

REM --- Etapa 1: Desinstalar a versão existente ---
echo Desinstalando Netskope Client existente...

REM Opção 1: Usando WMIC (mais genérico para aplicações instaladas)
echo Tentando desinstalar via WMIC...
wmic product where "name like '%%%NetskopeProductName%%%'" call uninstall /nointeractive > "%UninstallLogFile%"
echo Resultado da desinstalacao via WMIC (verifique "%UninstallLogFile%"):
type "%UninstallLogFile%"
echo.

REM Aguardar um pouco para a desinstalação concluir
echo Aguardando desinstalacao...
timeout /t 15 /nobreak >nul

REM Verificar se a desinstalação foi bem-sucedida (rudimentar)
REM Uma verificação mais robusta envolveria checar se o produto ainda está listado
tasklist /FI "IMAGENAME eq nsClient.exe" 2>NUL | find /I /N "nsClient.exe">NUL
if "%ERRORLEVEL%"=="0" (
    echo AVISO: O processo nsClient.exe ainda parece estar em execucao.
    echo A desinstalacao pode nao ter sido completa.
    echo Verifique "%UninstallLogFile%" para detalhes.
    REM Você pode adicionar uma tentativa de matar o processo aqui, mas com cuidado:
    REM taskkill /F /IM nsClient.exe /T
    REM timeout /t 5 /nobreak >nul
) else (
    echo Processo nsClient.exe nao encontrado, desinstalacao provavelmente OK.
)
echo.

REM --- Etapa 2: Instalar a nova versão ---
SET "FullInstallerPath=%InstallerPath%\%NetskopeInstallerName%"

echo Verificando se o instalador existe: "%FullInstallerPath%"
if not exist "%FullInstallerPath%" (
    echo ERRO: Instalador "%FullInstallerPath%" nao encontrado!
    echo Verifique as configuracoes InstallerPath e NetskopeInstallerName.
    pause
    exit /b 1
)

echo Instalando a nova versao do Netskope Client...
echo Opcoes de instalacao: %INSTALL_OPTIONS%
echo Log de instalacao sera salvo em: "%InstallLogFile%"

REM Se o instalador for .MSI
msiexec /i "%FullInstallerPath%" %INSTALL_OPTIONS% /L*v "%InstallLogFile%"

REM Se o instalador for .EXE, os parâmetros silenciosos podem variar. Exemplo:
REM "%FullInstallerPath%" /silent /norestart PARAMETROS_ADICIONAIS

REM Verificar o código de erro da instalação
if !errorlevel! equ 0 (
    echo Instalacao do Netskope Client concluida com sucesso (ou iniciada em segundo plano).
) else if !errorlevel! equ 3010 (
    echo Instalacao do Netskope Client concluida, reinicializacao necessaria.
) else (
    echo ERRO: A instalacao do Netskope Client falhou com o codigo de erro: !errorlevel!
    echo Verifique o arquivo de log: "%InstallLogFile%"
    pause
    exit /b 1
)

echo.
echo Processo concluido.
echo Verifique os logs:
echo   Desinstalacao: "%UninstallLogFile%"
echo   Instalacao:    "%InstallLogFile%"
echo.
echo E recomendado reiniciar o computador se solicitado ou se houver problemas.
pause
ENDLOCAL
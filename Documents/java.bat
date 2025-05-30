@echo off
echo Verificando e instalando/atualizando o Java (Adoptium Temurin JDK)...
echo.

REM Verifica se o Winget esta instalado
winget --version >nul 2>&1
if %errorlevel% neq 0 (
    echo Winget nao encontrado. Por favor, instale o Winget primeiro.
    echo Visite: https://aka.ms/getwinget
    pause
    exit /b 1
)

REM Tenta atualizar o Java Development Kit (JDK) do Adoptium Temurin
echo Tentando atualizar o JDK do Adoptium Temurin...
winget upgrade Temurin.JDK.21 --accept-package-agreements --accept-source-agreements

REM Se a atualizacao falhar (ou nao estiver instalado), tenta instalar
if %errorlevel% neq 0 (
    echo JDK nao atualizado ou nao encontrado. Tentando instalar...
    winget install Temurin.JDK.21 --accept-package-agreements --accept-source-agreements
)

if %errorlevel% equ 0 (
    echo.
    echo Java (Adoptium Temurin JDK) instalado/atualizado com sucesso!
) else (
    echo.
    echo Ocorreu um erro durante a instalacao/atualizacao do Java.
    echo Verifique as mensagens acima para mais detalhes.
)

echo.
echo Pressione qualquer tecla para sair...
pause >nul
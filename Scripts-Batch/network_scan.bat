@echo off

setlocal enabledelayedexpansion
set /a "contagem=0"

:: A sub-rede que será escaneada é definida pelo usuário
echo Digite a rede que deseja escanear (Ex. 10.33.109)
set /p "rede="

cls

:: Cria o arquivo de log no mesmo local onde o script está
set "log_file=.\Lista de IPs.log"
echo. > "%log_file%"

echo Gerando lista de IPs...

:: Cria um looping de range 2-254
for /l %%a in (2,1,254) do (
    :: Executa o comando "nslookup" em todos os IPs da rede definida anteriormente. Ex. 10.33.109.{2-254} utilizando o DNS padrão da máquina
    for /f "skip=3 delims=|" %%b in ('nslookup %rede%.%%a 2^>nul') do (
        :: Verifica se há algum equipamento com o IP
        echo %%b | find /i "não encontrado" >nul 2>&1
        if !errorlevel! equ 1 (
            :: Caso tenha, é registrado no log
            set /a "contagem=!contagem!+1"
            echo %%b >> "%log_file%"
            if !contagem! equ 2 (
                echo.>> "%log_file%"
                set /a "contagem=0"
            )
        )
    )
)

cls

:: O conteúdo do log é exibido no terminal
type "%log_file%"
pause
endlocal
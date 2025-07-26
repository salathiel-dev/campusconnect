@echo off
echo Testando conexao com o servidor CampusConnect...
echo.

REM Testa se a porta 8080 esta em uso
netstat -an | findstr ":8080" > nul
if %errorlevel% == 0 (
    echo [OK] Porta 8080 esta em uso - provavelmente o servidor esta rodando
) else (
    echo [ERRO] Porta 8080 nao esta em uso - servidor NAO esta rodando
    echo.
    echo Para iniciar o servidor:
    echo 1. Abra um terminal na pasta campusconnect-api
    echo 2. Execute: gradlew.bat bootRun
    echo.
    pause
    exit /b 1
)

echo.
echo Testando endpoint de health...
curl -s -o nul -w "Status HTTP: %%{http_code}" http://localhost:8080/health
echo.

echo.
echo Testando endpoint de login...
curl -s -o nul -w "Status HTTP: %%{http_code}" http://localhost:8080/auth/login
echo.

echo.
echo Teste completo!
pause

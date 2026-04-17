@echo off

echo.
echo 🛑 To stop services: docker-compose down
echo.
echo   - ARCHITECTURE.md - System architecture details
echo   - DEPLOYMENT.md - Deployment guide for all platforms
echo   - README_MVP.md - Project overview and features
echo 📚 Documentation:
echo.
echo   3. Run 'flutter run' in another terminal to start the mobile app
echo   2. Test the /api/v1/predict endpoint with a heart sound audio file
echo   1. Open http://localhost:8000/docs in your browser
echo 📝 Next Steps:
echo.
echo   - Health Check: http://localhost:8000/health
echo   - ReDoc: http://localhost:8000/redoc
echo   - Swagger UI: http://localhost:8000/docs
echo   - API URL: http://localhost:8000
echo 📍 API Endpoints:
echo.
echo 🎉 CardioAI is up and running!
echo.

echo ✅ Backend is ready!

)
    goto wait_loop
    timeout /t 1 /nobreak >nul
    set /a attempt=%attempt%+1
if errorlevel 1 (

powershell -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'http://localhost:8000/health' -UseBasicParsing > $null } catch { exit 1 }" >nul 2>&1
REM Try to check health

)
    exit /b 1
    docker-compose logs backend
    echo ❌ Backend failed to start. Check logs:
if %attempt% geq %max_attempts% (
:wait_loop

set attempt=0
set max_attempts=30
echo ⏳ Waiting for backend to be ready...
REM Wait for backend to be ready

docker-compose up --build -d
echo 🚀 Starting CardioAI Backend...
REM Build and start services

)
    echo ✅ .env file already exists
) else (
    echo ✅ .env file created. Update it with your settings if needed.
    copy .env.example .env
    echo 📝 Creating .env file from example...
if not exist .env (
REM Create .env file if it doesn't exist

echo ✅ Docker and Docker Compose found

)
    exit /b 1
    echo ❌ Docker Compose not found. Please install Docker Compose
if errorlevel 1 (
docker-compose --version >nul 2>&1
REM Check if Docker Compose is installed

)
    exit /b 1
    echo ❌ Docker not found. Please install Docker: https://docs.docker.com/get-docker/
if errorlevel 1 (
docker --version >nul 2>&1
REM Check if Docker is installed

echo ====================================
echo 🏥 CardioAI MVP - Quick Start Setup

setlocal enabledelayedexpansion

REM CardioAI Quick Start Script for Windows

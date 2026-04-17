#!/bin/bash
# CardioAI Quick Start Script

set -e

echo "🏥 CardioAI MVP - Quick Start Setup"
echo "===================================="

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    echo "❌ Docker not found. Please install Docker: https://docs.docker.com/get-docker/"
    exit 1
fi

# Check if Docker Compose is installed
if ! command -v docker-compose &> /dev/null; then
    echo "❌ Docker Compose not found. Please install Docker Compose"
    exit 1
fi

echo "✅ Docker and Docker Compose found"

# Create .env file if it doesn't exist
if [ ! -f .env ]; then
    echo "📝 Creating .env file from example..."
    cp .env.example .env
    echo "✅ .env file created. Update it with your settings if needed."
else
    echo "✅ .env file already exists"
fi

# Build and start services
echo "🚀 Starting CardioAI Backend..."
docker-compose up --build -d

# Wait for backend to be ready
echo "⏳ Waiting for backend to be ready..."
max_attempts=30
attempt=0

while [ $attempt -lt $max_attempts ]; do
    if curl -s http://localhost:8000/health > /dev/null 2>&1; then
        echo "✅ Backend is ready!"
        break
    fi
    attempt=$((attempt + 1))
    sleep 1
done

if [ $attempt -eq $max_attempts ]; then
    echo "❌ Backend failed to start. Check logs:"
    docker-compose logs backend
    exit 1
fi

echo ""
echo "🎉 CardioAI is up and running!"
echo ""
echo "📍 API Endpoints:"
echo "  - API URL: http://localhost:8000"
echo "  - Swagger UI: http://localhost:8000/docs"
echo "  - ReDoc: http://localhost:8000/redoc"
echo "  - Health Check: http://localhost:8000/health"
echo ""
echo "📝 Next Steps:"
echo "  1. Open http://localhost:8000/docs in your browser"
echo "  2. Test the /api/v1/predict endpoint with a heart sound audio file"
echo "  3. Run 'flutter run' in another terminal to start the mobile app"
echo ""
echo "📚 Documentation:"
echo "  - README_MVP.md - Project overview and features"
echo "  - DEPLOYMENT.md - Deployment guide for all platforms"
echo "  - ARCHITECTURE.md - System architecture details"
echo ""
echo "🛑 To stop services: docker-compose down"
echo ""


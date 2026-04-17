# CardioAI - Project Structure Guide

## 📁 Directory Tree

```
CardioAI/
│
├── 📄 README_MVP.md              ← START HERE! Project overview
├── 📄 DEPLOYMENT.md              ← Deployment guide
├── 📄 ARCHITECTURE.md            ← System architecture
├── 📄 TESTING.md                 ← Testing & API examples
├── 📄 PROJECT_STRUCTURE.md       ← This file
│
├── 🐳 Dockerfile                 ← Backend containerization
├── 🐳 docker-compose.yml         ← Local dev environment
├── 📝 .env.example               ← Environment variables template
├── 📝 .dockerignore              ← Docker build ignore
│
├── 🚀 start.sh                   ← Quick start (Linux/Mac)
├── 🚀 start.bat                  ← Quick start (Windows)
│
├── 📄 pubspec.yaml               ← Flutter dependencies
├── 📄 pubspec.lock               ← Locked dependency versions
├── 📄 analysis_options.yaml      ← Dart linter config
│
├── 📁 lib/                       ← FLUTTER FRONTEND
│   ├── main.dart                 ← App entry point
│   ├── app.dart                  ← App widget & BLoC setup
│   │
│   ├── 📁 config/                ← App configuration
│   │   ├── routes/               ← Navigation routing
│   │   └── themes/               ← UI themes & styles
│   │
│   ├── 📁 core/                  ← Core utilities
│   │   ├── constants/            ← App constants
│   │   ├── extensions/           ← Dart extensions
│   │   └── utils/                ← Helper utilities
│   │
│   ├── 📁 data/                  ← Data layer
│   │   ├── models/               ← Data models
│   │   ├── repositories/         ← API & local data access
│   │   └── local/                ← Local storage services
│   │
│   ├── 📁 logic/                 ← BLoC state management
│   │   ├── auth/                 ← Authentication logic
│   │   ├── prediction/           ← Prediction state
│   │   └── report/               ← Report generation state
│   │
│   ├── 📁 model/                 ← Domain models
│   │   └── [model files]
│   │
│   └── 📁 presentation/          ← UI layer
│       ├── screens/              ← App screens
│       ├── widgets/              ← Reusable widgets
│       └── pages/                ← Page layouts
│
├── 📁 backend/                   ← PYTHON/FASTAPI BACKEND
│   ├── main.py                   ← FastAPI app entry point
│   ├── requirements.txt          ← Python dependencies
│   ├── .env.example              ← Backend env variables
│   │
│   ├── 📁 core/                  ← ML pipelines & models
│   │   ├── model_repository.py   ← Model loading/management
│   │   ├── classification_pipeline.py  ← ML classification
│   │   ├── denoising_pipeline.py      ← Audio denoising
│   │   ├── xai_pipeline.py            ← Explainability (Grad-CAM)
│   │   └── __init__.py
│   │
│   ├── 📁 routers/               ← API route handlers
│   │   ├── prediction.py         ← Prediction endpoints
│   │   └── __init__.py
│   │
│   ├── 📁 schemas/               ← Pydantic data models
│   │   ├── prediction_schema.py  ← Request/Response schemas
│   │   └── __init__.py
│   │
│   ├── 🎵 heart_sound.wav        ← Sample audio for testing
│   ├── 🎵 noise.wav              ← Noise reference
│   ├── test_api.py               ← API testing script
│   └── __pycache__/              ← Python cache
│
├── 📁 assets/                    ← App assets
│   ├── app logo.png              ← App icon/logo
│   └── 📁 hart_sound/            ← Sample heart sounds
│       ├── 2530_AV.wav
│       ├── 2530_MV.wav
│       ├── 2530_PV.wav
│       └── 2530_TV.wav
│
├── 📁 android/                   ← Android native code
│   ├── build.gradle.kts
│   ├── settings.gradle.kts
│   ├── gradle.properties
│   ├── local.properties
│   │
│   └── 📁 app/
│       ├── build.gradle.kts      ← App build config
│       └── 📁 src/
│           ├── debug/
│           ├── main/
│           │   ├── AndroidManifest.xml
│           │   ├── kotlin/       ← Kotlin code
│           │   └── res/          ← Resources
│           └── profile/
│
├── 📁 ios/                       ← iOS native code
│   ├── Runner/                   ← iOS app code
│   ├── Runner.xcodeproj/         ← Xcode project
│   ├── Runner.xcworkspace/       ← Xcode workspace
│   └── 📁 Flutter/               ← Flutter configuration
│
├── 📁 web/                       ← Web build output
│   ├── index.html
│   ├── manifest.json
│   └── 📁 icons/
│
├── 📁 test/                      ← Dart unit tests
│   └── widget_test.dart
│
├── 📁 build/                     ← Build artifacts (generated)
│   ├── app/                      ← Android build output
│   ├── flutter_assets/           ← Flutter assets
│   └── [cache files]
│
└── 📝 README.md                  ← Original readme
```

---

## 🎯 Where to Start

### 1️⃣ **First Time Setup**
```bash
# Read the MVP overview
cat README_MVP.md

# Start the backend
./start.sh          # Linux/Mac
start.bat           # Windows
```

### 2️⃣ **Understand the Project**
1. Read `README_MVP.md` - Project overview
2. Check `ARCHITECTURE.md` - System design
3. Review `lib/app.dart` - App structure
4. Explore `backend/main.py` - Backend structure

### 3️⃣ **Run Locally**
```bash
# Terminal 1: Start backend
./start.sh

# Terminal 2: Start Flutter app
flutter run
```

### 4️⃣ **Test the API**
```bash
# Open Swagger UI
open http://localhost:8000/docs

# Or run test script
cd backend
python test_api.py
```

---

## 🔑 Key Files Explained

### Frontend (Flutter)

| File | Purpose |
|------|---------|
| `lib/main.dart` | App initialization & system UI setup |
| `lib/app.dart` | Root widget, BLoC providers setup |
| `lib/config/routes/app_router.dart` | Navigation routing |
| `lib/config/themes/app_theme.dart` | UI theme configuration |
| `lib/logic/prediction/prediction_bloc.dart` | Prediction state management |
| `lib/data/repositories/prediction_repository.dart` | API communication |
| `lib/presentation/screens/` | UI screens |

### Backend (Python)

| File | Purpose |
|------|---------|
| `backend/main.py` | FastAPI app setup & startup |
| `backend/routers/prediction.py` | API endpoints |
| `backend/core/classification_pipeline.py` | ML inference |
| `backend/core/denoising_pipeline.py` | Audio cleanup |
| `backend/core/xai_pipeline.py` | Explainability (Grad-CAM) |
| `backend/core/model_repository.py` | Model management |
| `backend/schemas/prediction_schema.py` | Data validation |

### Configuration

| File | Purpose |
|------|---------|
| `Dockerfile` | Backend containerization |
| `docker-compose.yml` | Local dev environment |
| `.env.example` | Environment variables template |
| `pubspec.yaml` | Flutter dependencies |
| `backend/requirements.txt` | Python dependencies |

### Documentation

| File | Purpose |
|------|---------|
| `README_MVP.md` | **Project overview (START HERE!)** |
| `DEPLOYMENT.md` | Deployment guide |
| `ARCHITECTURE.md` | System architecture |
| `TESTING.md` | Testing & API examples |
| `PROJECT_STRUCTURE.md` | This file |

---

## 🏗️ Architecture Layers

### Frontend Architecture (BLoC Pattern)

```
Presentation Layer (UI)
    └── Screens & Widgets
           │
           ▼
BLoC Layer (State Management)
    └── Events & States
           │
           ▼
Data Layer (Repositories)
    └── API Calls & Local Storage
           │
           ▼
Core Layer (Utilities)
    └── Constants, Extensions, Helpers
```

### Backend Architecture (FastAPI)

```
API Routes (routers/)
    └── /api/v1/predict, /health, etc.
           │
           ▼
Processing Pipelines (core/)
    ├── validation_pipeline
    ├── denoising_pipeline
    ├── classification_pipeline
    └── xai_pipeline
           │
           ▼
ML Models
    ├── Classifier
    ├── Denoiser
    └── Feature Extractors
```

---

## 📦 Dependencies

### Frontend (Flutter)
- **State Management**: flutter_bloc
- **Routing**: go_router
- **HTTP**: http client
- **Charts**: fl_chart
- **PDF**: pdf & printing
- **UI**: cupertino_icons, google_fonts, shimmer

### Backend (Python)
- **Framework**: FastAPI, Uvicorn
- **ML**: PyTorch, librosa
- **Processing**: scipy, numpy, scikit-learn
- **Audio**: soundfile, torchaudio
- **Validation**: pydantic

---

## 🚀 Quick Commands

```bash
# Frontend
flutter pub get              # Install dependencies
flutter run                  # Run app
flutter build apk            # Build Android APK
flutter build ipa            # Build iOS IPA
flutter test                 # Run tests

# Backend
pip install -r requirements.txt    # Install dependencies
python -m uvicorn main:app --reload  # Run dev server
pytest tests/                      # Run tests
docker-compose up --build          # Start with Docker

# General
./start.sh                   # Quick start (Unix)
start.bat                    # Quick start (Windows)
git clone [repo]             # Clone project
```

---

## 💡 Development Workflow

### Making Changes to Backend

1. Edit `backend/core/*.py` or `backend/routers/*.py`
2. API auto-reloads (if using `--reload`)
3. Check `/docs` for updated API
4. Test with curl or Postman

### Making Changes to Frontend

1. Edit `lib/**/*.dart`
2. Hot reload (R key in Flutter CLI)
3. Test in emulator/device
4. Run `flutter test` for unit tests

### Adding New Dependencies

**Frontend:**
```bash
flutter pub add package_name
```

**Backend:**
```bash
pip install package_name
pip freeze > backend/requirements.txt
```

---

## 🔍 Debugging

### View Logs

```bash
# Flutter logs
flutter logs

# Backend logs
docker-compose logs -f backend

# All logs
docker-compose logs -f
```

### Use Debugger

**Flutter:**
- Press `w` in CLI to open widget inspector
- Use VS Code Debug extension

**Python:**
- Use `pdb`: `import pdb; pdb.set_trace()`
- Use IDE debugger (PyCharm, VS Code)

---

## 📋 MVP Checklist

- [ ] Backend models load on startup
- [ ] API endpoints respond correctly
- [ ] Flutter app connects to backend
- [ ] Prediction endpoint works
- [ ] Results display in UI
- [ ] PDF export works
- [ ] Docker deployment works
- [ ] API documentation complete
- [ ] Error handling implemented
- [ ] Performance acceptable

---

**Last Updated**: March 2026  
**Project**: CardioAI MVP  
**Version**: 1.0


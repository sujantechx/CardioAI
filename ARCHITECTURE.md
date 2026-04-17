# CardioAI Architecture Documentation

## System Design Overview

```
┌─────────────────────────────────────────────────────────────────┐
│                    CLIENT LAYER (Flutter)                       │
│  ┌──────────────┬──────────────┬──────────────┬──────────────┐  │
│  │   iOS        │   Android    │   Web        │   Desktop    │  │
│  │   (Native)   │   (Native)   │   (Browser)  │   (Native)   │  │
│  └──────────────┴──────────────┴──────────────┴──────────────┘  │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
                    ┌────────────▼────────────┐
                    │   REST API (HTTP/TLS)   │
                    │   JSON Request/Response  │
                    └────────────┬────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│                   API LAYER (FastAPI)                            │
│  ┌─────────────────────────────────────────────────────────────┐ │
│  │  /health                  (Health check)                     │ │
│  │  /api/v1/predict          (Main inference)                   │ │
│  │  /api/v1/predictions      (History retrieval)               │ │
│  │  /docs, /redoc            (API documentation)               │ │
│  └─────────────────────────────────────────────────────────────┘ │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│                PROCESSING LAYER (Core Pipelines)                │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────────┐ │
│  │  Validation  │ │  Denoising   │ │  Classification Pipeline │ │
│  │  Pipeline    │ │  Pipeline    │ │  (ML Model Inference)   │ │
│  │              │ │              │ │                          │ │
│  │ - Audio fmt  │ │ - Spectral   │ │ - Feature extraction    │ │
│  │ - Duration   │ │ - Wavelet    │ │ - Mel-spectrogram       │ │
│  │ - Frequency  │ │ - Denoising  │ │ - CNN classification    │ │
│  │ - SNR check  │ │              │ │ - Grad-CAM (XAI)        │ │
│  └──────────────┘ └──────────────┘ └──────────────────────────┘ │
│                                                                  │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │          XAI Pipeline (Explainability)                   │   │
│  │  - Gradient computation                                  │   │
│  │  - Class Activation Maps (Grad-CAM)                     │   │
│  │  - Frequency band importance                            │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│              ML MODEL LAYER (PyTorch Models)                     │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │  Heart Sound Classification CNN                         │   │
│  │  - Input: 4kHz audio (mel-spectrogram)                  │   │
│  │  - Output: Normal/Murmur probability                    │   │
│  │  - Accuracy: >92%                                       │   │
│  │  - Inference: ~50ms (GPU), ~200ms (CPU)               │   │
│  │                                                          │   │
│  │  Denoising Model                                        │   │
│  │  - Input: Noisy heart sound                            │   │
│  │  - Output: Clean audio signal                          │   │
│  │  - SNR improvement: +8-15dB                            │   │
│  └──────────────────────────────────────────────────────────┘   │
└────────────────────────────────┬─────────────────────────────────┘
                                 │
┌────────────────────────────────▼─────────────────────────────────┐
│          STORAGE & INFRASTRUCTURE LAYER                          │
│  ┌──────────────┐ ┌──────────────┐ ┌──────────────────────────┐ │
│  │  Model Store │ │  Logs/Metrics│ │  Optional: Database      │ │
│  │              │ │              │ │                          │ │
│  │ - Classif.   │ │ - CloudWatch │ │ - Prediction history    │ │
│  │ - Denoise    │ │ - ELK Stack  │ │ - User accounts         │ │
│  │ - Local/S3   │ │ - Datadog    │ │ - PostgreSQL/MongoDB   │ │
│  └──────────────┘ └──────────────┘ └──────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### 1. Frontend Layer (Flutter)

#### Presentation Layer
```
lib/presentation/
├── screens/
│   ├── home_screen.dart         (Main dashboard)
│   ├── recording_screen.dart    (Audio recording)
│   ├── result_screen.dart       (Classification results)
│   ├── report_screen.dart       (PDF report view)
│   └── history_screen.dart      (Past predictions)
├── widgets/
│   ├── waveform_painter.dart    (Audio visualization)
│   ├── heatmap_widget.dart      (Grad-CAM visualization)
│   ├── result_card.dart         (Result display)
│   └── custom_buttons.dart
└── pages/
    └── app_navigator.dart       (Navigation structure)
```

#### BLoC (State Management)
```
lib/logic/
├── auth/
│   ├── auth_bloc.dart           (User authentication state)
│   ├── auth_event.dart
│   └── auth_state.dart
├── prediction/
│   ├── prediction_bloc.dart     (Prediction state)
│   ├── prediction_event.dart
│   └── prediction_state.dart
└── report/
    ├── report_bloc.dart         (Report generation state)
    ├── report_event.dart
    └── report_state.dart
```

#### Data Layer
```
lib/data/
├── models/
│   ├── audio_model.dart
│   ├── prediction_model.dart
│   └── user_model.dart
├── repositories/
│   ├── auth_repository.dart     (Auth logic)
│   ├── prediction_repository.dart (API calls)
│   └── report_repository.dart   (Report generation)
└── local/
    └── shared_preferences_service.dart
```

#### Core Utilities
```
lib/core/
├── constants/
│   ├── app_constants.dart       (API endpoints, timeouts)
│   └── ui_constants.dart        (Colors, sizes)
├── extensions/
│   └── string_extensions.dart
└── utils/
    ├── audio_service.dart       (Audio recording/playback)
    ├── api_client.dart          (HTTP client)
    └── validators.dart          (Input validation)
```

### 2. Backend Layer (FastAPI/Python)

#### API Routes
```
backend/routers/
└── prediction.py
    ├── POST /api/v1/predict              (Main endpoint)
    ├── GET  /api/v1/predictions          (History)
    └── GET  /api/v1/predictions/{id}    (Single prediction)
```

#### Processing Pipelines
```
backend/core/
├── validation_pipeline.py
│   └── Audio format, duration, frequency validation
│
├── denoising_pipeline.py
│   ├── Spectral subtraction
│   ├── Wavelet denoising
│   └── SNR calculation
│
├── classification_pipeline.py
│   ├── Feature extraction (mel-spectrogram)
│   ├── Model inference
│   ├── Confidence scoring
│   └── Result formatting
│
└── xai_pipeline.py
    ├── Grad-CAM computation
    ├── Feature importance calculation
    └── Visualization data generation
```

#### Model Management
```
backend/core/model_repository.py
├── load_models()           (Load on startup)
├── get_classifier()        (Get classification model)
├── get_denoiser()         (Get denoising model)
└── is_ready               (Health check)
```

#### Data Schemas
```
backend/schemas/
└── prediction_schema.py
    ├── PredictionRequest    (Input validation)
    └── PredictionResponse   (Output structure)
```

---

## Data Flow Diagrams

### User Recording Analysis Flow

```
┌──────────────┐
│ User Record  │ Audio (.wav)
│ Audio File   │
└──────┬───────┘
       │
       ▼
┌──────────────────────┐
│ Mobile App (Flutter) │
├──────────────────────┤
│ 1. Audio Processing  │
│ 2. UI Visualization  │
│ 3. Send to Backend   │
└──────┬───────────────┘
       │ HTTP POST (multipart/form-data)
       ▼
┌──────────────────────────┐
│ FastAPI Backend          │
├──────────────────────────┤
│ 1. Save temp file        │
│ 2. Validate audio        │
│ 3. Run denoising         │
│ 4. Extract features      │
│ 5. Run classifier        │
│ 6. Compute Grad-CAM      │
│ 7. Format response       │
└──────┬───────────────────┘
       │ JSON Response
       ▼
┌──────────────────────┐
│ Mobile App (Flutter) │
├──────────────────────┤
│ 1. Parse results     │
│ 2. Display results   │
│ 3. Show heatmap      │
│ 4. Enable export     │
└──────────────────────┘
```

### Request/Response Example

**Request:**
```http
POST /api/v1/predict HTTP/1.1
Host: api.cardioai.com
Content-Type: multipart/form-data

[Binary audio data]
```

**Response:**
```json
{
  "id": "pred-uuid-12345",
  "timestamp": "2026-03-22T10:30:00Z",
  "result": "Murmur",
  "confidence": 0.92,
  "normalProbability": 0.08,
  "murmurProbability": 0.92,
  "riskLevel": "high",
  "signalStats": {
    "duration": 3.5,
    "sampleRate": 4000,
    "meanAmplitude": 0.18,
    "snr": 14.2
  },
  "gradcamData": [0.01, 0.05, ..., 0.12],
  "waveformData": [0.001, 0.002, ..., -0.001],
  "spectrogramData": [[...], [...], ...]
}
```

---

## Technology Stack Details

### Frontend
| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | Flutter | 3.10+ |
| State Mgmt | BLoC | 9.1.1 |
| Routing | GoRouter | 17.1.0 |
| HTTP Client | http | 1.2.0 |
| UI Toolkit | Material 3 | Latest |
| Charts | FL Chart | 1.1.1 |
| PDF Export | pdf | 3.11.3 |
| File Picker | file_picker | 10.3.10 |
| Storage | shared_preferences | 2.5.4 |

### Backend
| Component | Technology | Version |
|-----------|-----------|---------|
| Framework | FastAPI | 0.115+ |
| Server | Uvicorn | 0.32.1 |
| ML Framework | PyTorch | 2.0+ |
| Audio Processing | librosa | 0.10.2 |
| Signal Processing | scipy, numpy | 1.26.4, 1.13.1 |
| Machine Learning | scikit-learn | 1.5.2 |
| Async | aiofiles | 23.2.1 |
| Validation | pydantic | 2.10.3 |

### Deployment & DevOps
| Component | Technology |
|-----------|-----------|
| Containerization | Docker |
| Orchestration | Docker Compose |
| CI/CD | GitHub Actions |
| Cloud Options | Railway, AWS, GCP, DO |
| Monitoring | CloudWatch, Datadog |
| Logging | ELK Stack, Sentry |

---

## Scalability Considerations

### Horizontal Scaling
```
Load Balancer (ALB/NLB)
    ├── Backend Instance 1
    ├── Backend Instance 2
    ├── Backend Instance 3
    └── Backend Instance N

Auto-scaling based on:
- CPU usage > 70%
- Memory usage > 80%
- Request queue depth
```

### Caching Strategy
```
┌─────────────┐
│ Flutter App │
│   (Local)   │
└──────┬──────┘
       │
       ▼
┌──────────────────┐
│ Redis Cache      │  ← Model inference results
│ (Server-side)    │  ← Denoised audio
└──────┬───────────┘
       │ Cache miss
       ▼
┌──────────────────┐
│ FastAPI Backend  │
└──────────────────┘
```

### Database Optimization (Future)
```
┌─────────────────┐
│  Primary DB     │
│ (Write queries) │
└────────┬────────┘
         │
    ┌────┴────┐
    ▼         ▼
┌────────┐ ┌────────┐
│Replica1│ │Replica2│ (Read replicas)
└────────┘ └────────┘
```

---

## Security Architecture

### Authentication Flow
```
┌──────────┐
│ Credentials
└─────┬────┘
      │
      ▼
┌──────────────────┐
│ OAuth 2.0 / JWT  │
│ Token generation │
└─────┬────────────┘
      │
      ▼
┌──────────────────────┐
│ API Authorization    │
│ Check token validity │
│ Verify permissions   │
└──────────────────────┘
```

### HTTPS/TLS
```
Client ←──SSL/TLS──→ Server
         Encrypted
```

### API Rate Limiting
```
Per-User Limit: 100 requests/minute
Per-IP Limit: 1000 requests/minute
Burst Limit: 10 requests/second
```

---

## Error Handling

### Error Response Structure
```json
{
  "detail": "Error message",
  "error_code": "INVALID_AUDIO_FORMAT",
  "timestamp": "2026-03-22T10:30:00Z",
  "request_id": "req-uuid-12345"
}
```

### Error Codes
| Code | Meaning | HTTP Status |
|------|---------|------------|
| INVALID_AUDIO_FORMAT | Unsupported format | 400 |
| INVALID_AUDIO_DURATION | Too long/short | 400 |
| INVALID_HEART_SOUND | Not a heart sound | 422 |
| MODEL_NOT_READY | Models still loading | 503 |
| INFERENCE_ERROR | ML model failed | 500 |
| UNAUTHORIZED | Invalid credentials | 401 |
| RATE_LIMIT_EXCEEDED | Too many requests | 429 |

---

## Monitoring & Observability

### Key Metrics
```
Backend Performance:
├── Request latency (p50, p95, p99)
├── Model inference time
├── Error rate
├── Throughput (req/sec)
├── GPU utilization
└── Memory usage

Application Health:
├── API endpoint availability
├── Model loading status
├── Database connection pool
└── Cache hit rate
```

### Logging Strategy
```
Structured Logs:
{
  "timestamp": "2026-03-22T10:30:00Z",
  "level": "INFO",
  "service": "cardioai-backend",
  "request_id": "req-12345",
  "user_id": "user-abc",
  "message": "Prediction completed",
  "duration_ms": 145,
  "model": "classifier-v1.0",
  "result": "Murmur"
}
```

---

## Version Management

### API Versioning
```
/api/v1/predict      ← Current version
/api/v2/predict      ← Future version (backward compatible)
```

### Model Versioning
```
Models stored as:
models/
├── classifier/
│   ├── v1.0/
│   ├── v1.1/
│   └── v2.0/
└── denoiser/
    ├── v1.0/
    └── v1.1/
```

---

**Last Updated**: March 2026  
**Architecture Version**: 1.0  
**Status**: Production-Ready MVP


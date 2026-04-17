# CardioAI MVP - Testing & API Examples

## 🧪 Quick Testing Guide

### 1. Test Backend Health

```bash
# Using curl
curl http://localhost:8000/health

# Expected response:
# {"status":"ok","models_loaded":true}
```

### 2. Access API Documentation

Open browser and go to:
```
http://localhost:8000/docs
```

This interactive Swagger UI allows you to:
- View all API endpoints
- See request/response schemas
- Test endpoints directly
- Download OpenAPI specification

### 3. Test Prediction Endpoint

#### Using Python
```python
import requests
import os

# Prepare request
url = "http://localhost:8000/api/v1/predict"
audio_file = open("backend/heart_sound.wav", "rb")

files = {"audio_file": audio_file}
response = requests.post(url, files=files)

print("Status Code:", response.status_code)
print("Response:", response.json())

audio_file.close()
```

#### Using cURL
```bash
curl -X POST "http://localhost:8000/api/v1/predict" \
  -H "accept: application/json" \
  -F "audio_file=@backend/heart_sound.wav"
```

#### Using JavaScript/Fetch
```javascript
const formData = new FormData();
const audioFile = document.getElementById('audio-input').files[0];
formData.append('audio_file', audioFile);

fetch('http://localhost:8000/api/v1/predict', {
  method: 'POST',
  body: formData
})
.then(response => response.json())
.then(data => console.log('Prediction:', data))
.catch(error => console.error('Error:', error));
```

#### Using Postman
1. Open Postman
2. Create new POST request to `http://localhost:8000/api/v1/predict`
3. Go to Body → form-data
4. Add key: `audio_file` (Type: File)
5. Select your heart sound audio file
6. Click Send

### 4. Test Prediction History Endpoint

```bash
curl "http://localhost:8000/api/v1/predictions?limit=10"
```

---

## 📊 Sample Prediction Response

```json
{
  "id": "a1b2c3d4-e5f6-47g8-h9i0-j1k2l3m4n5o6",
  "timestamp": "2026-03-22T10:30:00.000Z",
  "result": "Normal",
  "confidence": 0.95,
  "normalProbability": 0.95,
  "murmurProbability": 0.05,
  "riskLevel": "low",
  "signalStats": {
    "duration": 3.5,
    "sampleRate": 4000,
    "meanAmplitude": 0.15,
    "snr": 12.5,
    "frequencyRange": {
      "min": 50,
      "max": 500
    }
  },
  "gradcamData": [
    0.01, 0.05, 0.12, 0.18, 0.25, 0.22, 0.15, 0.08, 0.02
  ],
  "waveformData": [
    0.001, 0.002, 0.001, -0.001, 0.002, 0.001, 0.000, -0.001
  ],
  "spectrogramData": [
    [0.1, 0.2, 0.3],
    [0.15, 0.25, 0.35],
    [0.12, 0.22, 0.32]
  ]
}
```

---

## 🐛 Debugging & Troubleshooting

### Backend Logs

```bash
# View all logs
docker-compose logs -f backend

# View last 100 lines
docker-compose logs --tail=100 backend

# Follow real-time logs
docker-compose logs -f backend

# View logs from all services
docker-compose logs -f
```

### Common Issues

#### Issue: "Models not ready"
```bash
# Check backend logs
docker-compose logs backend

# Restart backend
docker-compose restart backend

# Wait for model loading (usually 30-60 seconds)
```

#### Issue: "Connection refused"
```bash
# Check if backend is running
docker ps | grep cardioai-backend

# Start backend
docker-compose up -d backend

# Test connection
curl http://localhost:8000/health
```

#### Issue: "Audio format not supported"
- Supported formats: WAV, MP3
- Sample rate: 4000 Hz (will be resampled if different)
- Duration: 0.5 - 10 seconds
- File size: < 5 MB

#### Issue: "Out of memory"
```bash
# Increase Docker memory limit
# Edit docker-compose.yml:
services:
  backend:
    deploy:
      resources:
        limits:
          memory: 2G
```

---

## 📈 Performance Testing

### Load Testing with Apache Bench

```bash
# Single request test
ab -n 1 -c 1 http://localhost:8000/health

# Load test (100 requests, 10 concurrent)
ab -n 100 -c 10 http://localhost:8000/health
```

### Load Testing with wrk

```bash
# Install wrk
# macOS: brew install wrk
# Ubuntu: apt-get install wrk

# Run load test
wrk -t4 -c100 -d30s http://localhost:8000/health
```

### Load Testing with Locust

```bash
# Install
pip install locust

# Create locustfile.py
cat > locustfile.py << 'EOF'
from locust import HttpUser, task

class CardioAIUser(HttpUser):
    @task
    def health_check(self):
        self.client.get("/health")
EOF

# Run
locust -f locustfile.py --host=http://localhost:8000
# Open http://localhost:8089
```

---

## ✅ Test Checklist for MVP Validation

### Functionality Tests
- [ ] Health endpoint responds
- [ ] API documentation loads
- [ ] Prediction endpoint accepts audio file
- [ ] Response contains required fields
- [ ] Confidence score is between 0-1
- [ ] Risk level is valid (low/medium/high)
- [ ] Grad-CAM heatmap generated
- [ ] History endpoint returns predictions

### Performance Tests
- [ ] Single prediction < 1 second (CPU)
- [ ] Single prediction < 500ms (GPU)
- [ ] Can handle 10 concurrent requests
- [ ] Memory usage stable after warmup
- [ ] No memory leaks after 100 predictions

### Edge Cases
- [ ] Empty audio file handling
- [ ] Very short audio (< 0.5s)
- [ ] Very long audio (> 10s)
- [ ] Corrupted audio file
- [ ] Unsupported format (not WAV/MP3)
- [ ] Zero-amplitude audio
- [ ] Very noisy audio

### Error Handling
- [ ] 400 Bad Request for invalid input
- [ ] 422 Unprocessable Entity for invalid audio
- [ ] 503 Service Unavailable when models not ready
- [ ] 500 Internal Server Error for processing failures
- [ ] Proper error messages in response

---

## 📱 Flutter App Testing

### Test API Connection

```dart
// In your Flutter app
import 'package:http/http.dart' as http;

void testAPI() async {
  try {
    final response = await http.get(
      Uri.parse('http://localhost:8000/health'),
    ).timeout(const Duration(seconds: 5));
    
    if (response.statusCode == 200) {
      print('✅ Backend connection OK');
      print('Response: ${response.body}');
    } else {
      print('❌ Unexpected status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Connection failed: $e');
  }
}
```

### Test with Mock Audio

```dart
// Record test audio
final audioPath = await recordAudio();

// Send to backend
final prediction = await predictionRepository.predict(audioPath);

// Verify response
assert(prediction.result != null);
assert(prediction.confidence >= 0 && prediction.confidence <= 1);
assert(['Normal', 'Murmur'].contains(prediction.result));
```

---

## 📊 Monitoring & Analytics

### Response Time Tracking

```bash
# Test response time
time curl http://localhost:8000/api/v1/predict -F "audio_file=@heart_sound.wav"
```

### Model Accuracy Validation

```python
# test_accuracy.py
import requests
import os
from pathlib import Path

test_files_dir = "test_audio_files"
results = {
    "normal": [],
    "murmur": []
}

for audio_file in Path(test_files_dir).glob("*.wav"):
    category = audio_file.stem.split("_")[0]
    
    with open(audio_file, 'rb') as f:
        response = requests.post(
            "http://localhost:8000/api/v1/predict",
            files={"audio_file": f}
        )
    
    prediction = response.json()
    results[category].append(prediction)

# Analyze accuracy
# ... compare predictions with expected labels
```

---

## 🔐 Security Testing

### Check CORS Headers

```bash
curl -H "Origin: http://localhost:3000" \
     -H "Access-Control-Request-Method: POST" \
     -H "Access-Control-Request-Headers: Content-Type" \
     -X OPTIONS http://localhost:8000/api/v1/predict -v
```

### Test Input Validation

```bash
# Empty file
curl -X POST "http://localhost:8000/api/v1/predict" \
  -F "audio_file=@/dev/null"

# Invalid format
echo "not audio" > test.txt
curl -X POST "http://localhost:8000/api/v1/predict" \
  -F "audio_file=@test.txt"
```

---

**Last Updated**: March 2026  
**MVP Version**: 1.0


<div align="center">
  <img src="assets/app logo.png" alt="CardioAI Logo" width="120" style="border-radius: 20px; box-shadow: 0px 10px 20px rgba(0, 0, 0, 0.1);">
  <h1>CardioAI: Explainable Heart Sound Analysis System</h1>
  <p>An Edge-to-Cloud Deep Learning Application for Real-Time Cardiac Arrhythmia and Murmur Detection</p>

  [![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev/)
  [![PyTorch](https://img.shields.io/badge/PyTorch-2.x-EE4C2C?logo=pytorch)](https://pytorch.org/)
  [![ONNX](https://img.shields.io/badge/ONNX-Runtime-005CED?logo=onnx)](https://onnxruntime.ai/)
  [![FastAPI](https://img.shields.io/badge/FastAPI-0.100+-009688?logo=fastapi)](https://fastapi.tiangolo.com/)
  <br>
</div>

---

## 🏛 Academic Credits

This major project was conceptualized, designed, and developed as part of the academic curriculum at **Parala Maharaja Engineering College (PMEC)**.

**Under the Guidance of:**  
👨‍🏫 **Dr. Niranjan Panigrahi**  
*Assistant Professor, Department of Computer Science and Engineering (CSE)*

**Developed by Team Members:**  
1. **Radhakant Panda** `(2201109069)`  
2. **Raja Kumar Bisi** `(2201109070)`  
3. **Rajat Kumar Dalai** `(2201109071)`  
4. **Sujan Sahu** `(2321109121)`  

---

## 📖 Project Overview

**CardioAI** is a sophisticated, offline-first medical diagnostic tool designed to classify heart sounds (Phonocardiograms). Leveraging state-of-the-art Deep Learning models directly on mobile devices (Edge AI), it provides instant, clinically-relevant screening for heart murmurs and arrhythmias without requiring an internet connection. 

The system utilizes an automated **Audio Preprocessor pipeline** (PCM to Mel Spectrogram conversion) and an **INT8 Quantized ResNet-based Classifier** driven by ONNX Runtime. For advanced computational tasks, the platform connects to a high-performance **FastAPI backend** to provide Explainable AI (XAI) outputs, including Grad-CAM heatmaps and SHAP feature analysis.

---

## ✨ Key Features

- **⚡ Edge Inference (Offline Capable):** The primary heart-sound classification model (Normal vs. Murmur) is compressed via ONNX and runs entirely on the smartphone CPU/NPU in under 150ms.
- **🛡 Privacy-Preserving Computing:** sensitive audio data does not need to leave the patient's device for baseline diagnostics. 
- **🔊 Native Signal Processing:** A pure Dart-based mathematics engine extracts uncompressed `.wav` PCM files and computes targeted 64-band Mel Spectrograms dynamically.
- **🔍 Explainable AI (XAI):** Visualizes deep learning decisions using Grad-CAM heatmaps to help clinicians understand which acoustic cycles triggered the classification.
- **🗃 Persistent Local History:** Uses an embedded SQLite transactional database to securely persist patient histories, prediction data, and generate offline PDF clinical reports.
- **📱 Fluid UI/UX:** Built with a modern, glassmorphism-inspired design system using Flutter's hardware-accelerated Vulkan (Impeller) rendering engine.

---

## 🏗 Architecture & Tech Stack

### 1. Mobile Client (Frontend)
* **Framework:** Flutter / Dart
* **State Management:** BLoC (Business Logic Component) Pattern
* **On-Device AI Engine:** `flutter_onnxruntime`
* **Local Database:** `sqflite` (SQLite)
* **Report Generation:** `pdf`, `printing`

### 2. Deep Learning Pipelines (Model Training)
* **Framework:** PyTorch & Torchvision
* **Acoustic Feature Engineering:** Librosa (Python)
* **Architectures Used:** 
  * *Classifier:* Custom ResNet + Temporal Attention Module
  * *Denoiser:* Latent Diffusion Models (LDM) & Variational Autoencoders (VAE)
* **Optimization:** INT8 Dynamic Quantization for Mobile Edge

### 3. Cloud Analysis (Backward Compatibility)
* **Framework:** FastAPI (Python)
* **Role:** Executes the Latent Diffusion denoiser and Grad-CAM generation for complex cases requiring massive GPU overhead.

---

## ⚙️ How to Use (Local Setup)

### Prerequisites
* Flutter SDK (Version 3.19.0 or higher)
* Android Studio (with NDK installed)
* Python 3.10+ (If running the local XAI Backend)

### 1. Model Configuration
Place the compressed ONNX model (`classifier_quantized.onnx`) into the Flutter assets directory:
```bash
CardioAI/assets/models/classifier_quantized.onnx
```

### 2. Running the Flutter App
To launch the application in debug mode on an attached device or emulator:
```bash
flutter pub get
flutter run
```

### 3. Building for Production (Release APK)
To build a highly optimized, tree-shaken, standalone Android package:
```bash
flutter build apk --release
```
*The resulting APK will be found at:* `build/app/outputs/flutter-apk/app-release.apk`

---

## 📊 Evaluation & Metrics
During validation on the standardized PhysioNet datasets, the Quantized Edge Model achieved:
- **Validation Accuracy:** `~99.8%`
- **Class Weights:** Successfully mitigated clinical dataset imbalance (Normal=`0.63`, Murmur=`2.44`)
- **Inference Latency:** `< 120ms` (Avg on Snapdragon/MediaTek processors)
- **Model Footprint:** `1.7 MB` (Down from 18 MB baseline)

---

<div align="center">
  <i>Developed to bridge the gap between complex artificial intelligence and practical clinical cardiology.</i><br>
  <b>PMEC | Dept. of CSE | 2026</b>
</div>

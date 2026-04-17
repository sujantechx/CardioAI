import 'dart:typed_data';
import '../../core/inference/on_device_classifier.dart';
import '../../core/network/api_client.dart';
import '../models/patient_model.dart';
import '../models/prediction_model.dart';

/// ═══════════════════════════════════════════════════════════
/// CardioAI — Prediction Repository (Hybrid Inference)
/// ═══════════════════════════════════════════════════════════
///
/// Supports two inference modes:
///   1. ON-DEVICE  — ONNX classifier runs locally (offline)
///   2. SERVER     — Full pipeline via FastAPI (online)
///
/// Strategy: Try on-device first → fall back to server.
/// If both fail, throw an error to the BLoC.
/// ═══════════════════════════════════════════════════════════
class PredictionRepository {
  final ApiClient _apiClient = ApiClient();
  final OnDeviceClassifier _onDeviceClassifier = OnDeviceClassifier();

  bool _modelInitialized = false;

  /// Initialize on-device model (call once at app startup).
  Future<void> initialize() async {
    if (!_modelInitialized) {
      _modelInitialized = await _onDeviceClassifier.loadModel();
    }
  }

  /// Whether on-device inference is available.
  bool get isOnDeviceAvailable => _onDeviceClassifier.isLoaded;

  /// Run prediction — tries on-device first, then server.
  Future<PredictionModel> predict(
    PatientModel patient,
    Uint8List audioBytes,
    String fileName,
  ) async {
    // Ensure model initialization was attempted
    if (!_modelInitialized) {
      await initialize();
    }

    // ── Strategy 1: On-device inference (offline capable) ──
    if (_onDeviceClassifier.isLoaded) {
      try {
        return await _onDeviceClassifier.classify(audioBytes, fileName);
      } catch (e) {
        // On-device failed — fall through to server
      }
    }

    // ── Strategy 2: Server inference (full pipeline + XAI) ──
    try {
      return await _apiClient.predictHeartSound(audioBytes, fileName, patient);
    } catch (e) {
      // Server also failed
      if (_onDeviceClassifier.isLoaded) {
        throw Exception(
          'Analysis failed. Please check the audio file and try again.',
        );
      } else {
        throw Exception(
          'Could not connect to the server and no on-device model found.\n\n'
          'To use offline mode, export the classifier model from Colab '
          'and place "classifier_quantized.onnx" in assets/models/.',
        );
      }
    }
  }

  /// Force server-only prediction (for full XAI analysis).
  Future<PredictionModel> predictOnServer(
    PatientModel patient,
    Uint8List audioBytes,
    String fileName,
  ) async {
    return await _apiClient.predictHeartSound(audioBytes, fileName, patient);
  }

  /// Force on-device-only prediction.
  Future<PredictionModel> predictOnDevice(
    Uint8List audioBytes,
    String fileName,
  ) async {
    if (!_onDeviceClassifier.isLoaded) {
      throw Exception('On-device model not available.');
    }
    return await _onDeviceClassifier.classify(audioBytes, fileName);
  }

  void dispose() {
    _onDeviceClassifier.dispose();
  }
}

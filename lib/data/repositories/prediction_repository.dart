import 'dart:typed_data';
import '../../core/network/api_client.dart';
import '../models/patient_model.dart';
import '../models/prediction_model.dart';

class PredictionRepository {
  final ApiClient _apiClient = ApiClient();

  /// Call the FastAPI prediction endpoint instead of dummy data
  Future<PredictionModel> predict(PatientModel patient, Uint8List audioBytes, String fileName) async {
    return await _apiClient.predictHeartSound(audioBytes, fileName, patient);
  }
}

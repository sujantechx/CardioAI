import 'dart:math';
import '../models/patient_model.dart';
import '../models/prediction_model.dart';
import '../../core/utils/dummy_data.dart';

class PredictionRepository {
  // Simulate prediction API call
  Future<PredictionModel> predict(PatientModel patient) async {
    // Simulate processing time
    await Future.delayed(const Duration(seconds: 3));

    // Randomly decide normal or murmur for demo
    final random = Random();
    if (random.nextDouble() > 0.4) {
      return DummyData.generateNormalPrediction();
    } else {
      return DummyData.generateMurmurPrediction();
    }
  }
}

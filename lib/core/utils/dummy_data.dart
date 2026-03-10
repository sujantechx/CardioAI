import 'dart:math';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';
import '../../data/models/report_model.dart';

class DummyData {
  DummyData._();

  static final Random _random = Random(42);

  // Generate dummy waveform data
  static List<double> generateWaveform({int length = 500}) {
    final List<double> data = [];
    for (int i = 0; i < length; i++) {
      double t = i / 100.0;
      // Simulate heart sound waveform: S1 and S2 peaks
      double s1 = 0.8 * exp(-pow((t % 1.0 - 0.1), 2) / 0.003);
      double s2 = 0.5 * exp(-pow((t % 1.0 - 0.4), 2) / 0.002);
      double noise = (_random.nextDouble() - 0.5) * 0.05;
      data.add(s1 + s2 + noise);
    }
    return data;
  }

  // Generate dummy spectrogram data
  static List<List<double>> generateSpectrogram({
    int rows = 64,
    int cols = 128,
  }) {
    final List<List<double>> data = [];
    for (int i = 0; i < rows; i++) {
      final List<double> row = [];
      for (int j = 0; j < cols; j++) {
        double freq = i / rows;
        double time = j / cols;
        double value =
            0.5 *
            exp(-pow(freq - 0.3, 2) / 0.05) *
            (0.7 + 0.3 * sin(time * 6 * pi));
        value +=
            0.3 *
            exp(-pow(freq - 0.6, 2) / 0.03) *
            (0.5 + 0.5 * cos(time * 4 * pi));
        value += _random.nextDouble() * 0.1;
        row.add(value.clamp(0.0, 1.0));
      }
      data.add(row);
    }
    return data;
  }

  // Generate dummy GradCAM heatmap data
  static List<List<double>> generateGradcam({int rows = 64, int cols = 128}) {
    final List<List<double>> data = [];
    double centerX = 0.35 + _random.nextDouble() * 0.3;
    double centerY = 0.3 + _random.nextDouble() * 0.4;
    for (int i = 0; i < rows; i++) {
      final List<double> row = [];
      for (int j = 0; j < cols; j++) {
        double x = j / cols;
        double y = i / rows;
        double dist = sqrt(pow(x - centerX, 2) + pow(y - centerY, 2));
        double value = exp(-dist * dist / 0.08);
        value +=
            0.3 *
            exp(
              -pow(x - (centerX + 0.2), 2) / 0.02 - pow(y - centerY, 2) / 0.03,
            );
        row.add(value.clamp(0.0, 1.0));
      }
      data.add(row);
    }
    return data;
  }

  // Generate feature importance for SHAP
  static Map<String, double> generateFeatureImportance() {
    return {
      'S1 Amplitude': 0.25 + _random.nextDouble() * 0.1,
      'S2 Amplitude': 0.18 + _random.nextDouble() * 0.08,
      'Systolic Duration': 0.15 + _random.nextDouble() * 0.05,
      'Diastolic Duration': 0.12 + _random.nextDouble() * 0.05,
      'Heart Rate': 0.10 + _random.nextDouble() * 0.05,
      'Frequency Peak': 0.08 + _random.nextDouble() * 0.04,
      'Signal Energy': 0.06 + _random.nextDouble() * 0.03,
      'Zero Crossing Rate': 0.04 + _random.nextDouble() * 0.02,
    };
  }

  // Generate a dummy prediction (Normal)
  static PredictionModel generateNormalPrediction() {
    double confidence = 0.85 + _random.nextDouble() * 0.12;
    return PredictionModel(
      id: 'pred_${DateTime.now().millisecondsSinceEpoch}',
      result: 'Normal',
      confidence: confidence,
      riskLevel: 'Low Risk',
      normalProbability: confidence,
      murmurProbability: 1.0 - confidence,
      waveformData: generateWaveform(),
      spectrogramData: generateSpectrogram(),
      gradcamData: generateGradcam(),
      featureImportance: generateFeatureImportance(),
      signalStats: SignalStats(
        duration: 5.0 + _random.nextDouble() * 3,
        sampleRate: 4000,
        snrBefore: 8.5 + _random.nextDouble() * 3,
        snrAfter: 18.0 + _random.nextDouble() * 5,
        meanAmplitude: 0.12 + _random.nextDouble() * 0.05,
        maxAmplitude: 0.78 + _random.nextDouble() * 0.2,
        heartRate: 68 + _random.nextInt(20),
      ),
      predictedAt: DateTime.now(),
    );
  }

  // Generate a dummy prediction (Murmur)
  static PredictionModel generateMurmurPrediction() {
    double confidence = 0.75 + _random.nextDouble() * 0.2;
    return PredictionModel(
      id: 'pred_${DateTime.now().millisecondsSinceEpoch}',
      result: 'Murmur',
      confidence: confidence,
      riskLevel: confidence > 0.85 ? 'High Risk' : 'Medium Risk',
      normalProbability: 1.0 - confidence,
      murmurProbability: confidence,
      waveformData: generateWaveform(length: 500),
      spectrogramData: generateSpectrogram(),
      gradcamData: generateGradcam(),
      featureImportance: generateFeatureImportance(),
      signalStats: SignalStats(
        duration: 5.0 + _random.nextDouble() * 3,
        sampleRate: 4000,
        snrBefore: 6.0 + _random.nextDouble() * 3,
        snrAfter: 15.0 + _random.nextDouble() * 5,
        meanAmplitude: 0.15 + _random.nextDouble() * 0.08,
        maxAmplitude: 0.85 + _random.nextDouble() * 0.15,
        heartRate: 75 + _random.nextInt(25),
      ),
      predictedAt: DateTime.now(),
    );
  }

  // Generate dummy history
  static List<ReportModel> generateHistory() {
    final List<ReportModel> reports = [];
    final names = [
      'John Doe',
      'Jane Smith',
      'David Wilson',
      'Sarah Johnson',
      'Mike Brown',
    ];
    final locations = ['Aortic', 'Mitral', 'Tricuspid', 'Pulmonary'];

    for (int i = 0; i < 8; i++) {
      final patient = PatientModel(
        id: 'pat_$i',
        name: names[i % names.length],
        age: 25 + _random.nextInt(50),
        gender: i % 2 == 0 ? 'Male' : 'Female',
        recordingLocation: locations[i % locations.length],
        audioFileName: 'recording_$i.wav',
        recordedAt: DateTime.now().subtract(Duration(days: i * 3)),
      );

      final prediction = i % 3 == 0
          ? generateMurmurPrediction()
          : generateNormalPrediction();

      reports.add(
        ReportModel(
          id: 'report_$i',
          patient: patient,
          prediction: prediction,
          generatedAt: DateTime.now().subtract(Duration(days: i * 3)),
        ),
      );
    }

    return reports;
  }
}

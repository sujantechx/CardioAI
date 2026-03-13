import 'package:equatable/equatable.dart';

class PredictionModel extends Equatable {
  final String id;
  final String result; // 'Normal' or 'Murmur'
  final double confidence;
  final String riskLevel;
  final double normalProbability;
  final double murmurProbability;
  final List<double> waveformData;
  final List<List<double>> spectrogramData;
  final List<List<double>> gradcamData;
  final Map<String, double> featureImportance;
  final SignalStats signalStats;
  final DateTime predictedAt;
  final String interpretation;

  const PredictionModel({
    required this.id,
    required this.result,
    required this.confidence,
    required this.riskLevel,
    required this.normalProbability,
    required this.murmurProbability,
    required this.waveformData,
    required this.spectrogramData,
    required this.gradcamData,
    required this.featureImportance,
    required this.signalStats,
    required this.predictedAt,
    this.interpretation = 'The AI model evaluated this scan and found no significant issues. Normal physiological parameters observed.',
  });

  bool get isMurmur => result == 'Murmur';
  bool get isNormal => result == 'Normal';

  @override
  List<Object?> get props => [
    id,
    result,
    confidence,
    riskLevel,
    normalProbability,
    murmurProbability,
    predictedAt,
  ];
}

class SignalStats extends Equatable {
  final double duration;
  final int sampleRate;
  final double snrBefore;
  final double snrAfter;
  final double meanAmplitude;
  final double maxAmplitude;
  final int heartRate;

  const SignalStats({
    required this.duration,
    required this.sampleRate,
    required this.snrBefore,
    required this.snrAfter,
    required this.meanAmplitude,
    required this.maxAmplitude,
    required this.heartRate,
  });

  @override
  List<Object?> get props => [
    duration,
    sampleRate,
    snrBefore,
    snrAfter,
    meanAmplitude,
    maxAmplitude,
    heartRate,
  ];
}

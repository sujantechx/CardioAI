import 'dart:convert';
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

  /// Convert to a JSON-compatible map for SQLite storage.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'result': result,
      'confidence': confidence,
      'riskLevel': riskLevel,
      'normalProbability': normalProbability,
      'murmurProbability': murmurProbability,
      'waveformData': jsonEncode(waveformData),
      'spectrogramData': jsonEncode(spectrogramData),
      'gradcamData': jsonEncode(gradcamData),
      'featureImportance': jsonEncode(featureImportance),
      'signalStats': jsonEncode(signalStats.toJson()),
      'predictedAt': predictedAt.toIso8601String(),
      'interpretation': interpretation,
    };
  }

  /// Reconstruct from a JSON map (e.g. from SQLite row).
  factory PredictionModel.fromJson(Map<String, dynamic> json) {
    return PredictionModel(
      id: json['id'] as String,
      result: json['result'] as String,
      confidence: (json['confidence'] as num).toDouble(),
      riskLevel: json['riskLevel'] as String,
      normalProbability: (json['normalProbability'] as num).toDouble(),
      murmurProbability: (json['murmurProbability'] as num).toDouble(),
      waveformData: (json['waveformData'] is String
              ? jsonDecode(json['waveformData'] as String) as List
              : json['waveformData'] as List)
          .map<double>((e) => (e as num).toDouble())
          .toList(),
      spectrogramData: (json['spectrogramData'] is String
              ? jsonDecode(json['spectrogramData'] as String) as List
              : json['spectrogramData'] as List)
          .map<List<double>>(
            (row) => (row as List).map<double>((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
      gradcamData: (json['gradcamData'] is String
              ? jsonDecode(json['gradcamData'] as String) as List
              : json['gradcamData'] as List)
          .map<List<double>>(
            (row) => (row as List).map<double>((e) => (e as num).toDouble()).toList(),
          )
          .toList(),
      featureImportance: (json['featureImportance'] is String
              ? jsonDecode(json['featureImportance'] as String) as Map<String, dynamic>
              : json['featureImportance'] as Map<String, dynamic>)
          .map((k, v) => MapEntry(k, (v as num).toDouble())),
      signalStats: SignalStats.fromJson(
        json['signalStats'] is String
            ? jsonDecode(json['signalStats'] as String) as Map<String, dynamic>
            : json['signalStats'] as Map<String, dynamic>,
      ),
      predictedAt: DateTime.parse(json['predictedAt'] as String),
      interpretation: json['interpretation'] as String? ??
          'The AI model evaluated this scan and found no significant issues.',
    );
  }

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

  Map<String, dynamic> toJson() {
    return {
      'duration': duration,
      'sampleRate': sampleRate,
      'snrBefore': snrBefore,
      'snrAfter': snrAfter,
      'meanAmplitude': meanAmplitude,
      'maxAmplitude': maxAmplitude,
      'heartRate': heartRate,
    };
  }

  factory SignalStats.fromJson(Map<String, dynamic> json) {
    return SignalStats(
      duration: (json['duration'] as num).toDouble(),
      sampleRate: (json['sampleRate'] as num).toInt(),
      snrBefore: (json['snrBefore'] as num).toDouble(),
      snrAfter: (json['snrAfter'] as num).toDouble(),
      meanAmplitude: (json['meanAmplitude'] as num).toDouble(),
      maxAmplitude: (json['maxAmplitude'] as num).toDouble(),
      heartRate: (json['heartRate'] as num).toInt(),
    );
  }

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

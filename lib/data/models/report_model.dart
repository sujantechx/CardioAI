import 'package:equatable/equatable.dart';
import 'patient_model.dart';
import 'prediction_model.dart';

class ReportModel extends Equatable {
  final String id;
  final PatientModel patient;
  final PredictionModel prediction;
  final DateTime generatedAt;
  final String? pdfPath;

  const ReportModel({
    required this.id,
    required this.patient,
    required this.prediction,
    required this.generatedAt,
    this.pdfPath,
  });

  ReportModel copyWith({
    String? id,
    PatientModel? patient,
    PredictionModel? prediction,
    DateTime? generatedAt,
    String? pdfPath,
  }) {
    return ReportModel(
      id: id ?? this.id,
      patient: patient ?? this.patient,
      prediction: prediction ?? this.prediction,
      generatedAt: generatedAt ?? this.generatedAt,
      pdfPath: pdfPath ?? this.pdfPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient': patient.toJson(),
      'prediction': prediction.toJson(),
      'generatedAt': generatedAt.toIso8601String(),
      'pdfPath': pdfPath,
    };
  }

  factory ReportModel.fromJson(Map<String, dynamic> json) {
    return ReportModel(
      id: json['id'] as String,
      patient: PatientModel.fromJson(json['patient'] as Map<String, dynamic>),
      prediction: PredictionModel.fromJson(json['prediction'] as Map<String, dynamic>),
      generatedAt: DateTime.parse(json['generatedAt'] as String),
      pdfPath: json['pdfPath'] as String?,
    );
  }

  @override
  List<Object?> get props => [id, patient, prediction, generatedAt, pdfPath];
}

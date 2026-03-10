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

  @override
  List<Object?> get props => [id, patient, prediction, generatedAt, pdfPath];
}

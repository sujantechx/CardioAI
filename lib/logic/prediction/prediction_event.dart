import 'dart:typed_data';
import 'package:equatable/equatable.dart';
import '../../data/models/patient_model.dart';

abstract class PredictionEvent extends Equatable {
  const PredictionEvent();

  @override
  List<Object?> get props => [];
}

class PredictionRequested extends PredictionEvent {
  final PatientModel patient;
  final Uint8List audioBytes;
  final String fileName;

  const PredictionRequested(this.patient, this.audioBytes, this.fileName);

  @override
  List<Object?> get props => [patient, audioBytes, fileName];
}

class PredictionReset extends PredictionEvent {}

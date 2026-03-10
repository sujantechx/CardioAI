import 'package:equatable/equatable.dart';
import '../../data/models/patient_model.dart';

abstract class PredictionEvent extends Equatable {
  const PredictionEvent();

  @override
  List<Object?> get props => [];
}

class PredictionRequested extends PredictionEvent {
  final PatientModel patient;

  const PredictionRequested(this.patient);

  @override
  List<Object?> get props => [patient];
}

class PredictionReset extends PredictionEvent {}

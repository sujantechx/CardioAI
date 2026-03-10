import 'package:equatable/equatable.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';

abstract class PredictionState extends Equatable {
  const PredictionState();

  @override
  List<Object?> get props => [];
}

class PredictionInitial extends PredictionState {}

class PredictionLoading extends PredictionState {}

class PredictionSuccess extends PredictionState {
  final PredictionModel prediction;
  final PatientModel patient;

  const PredictionSuccess({required this.prediction, required this.patient});

  @override
  List<Object?> get props => [prediction, patient];
}

class PredictionError extends PredictionState {
  final String message;

  const PredictionError(this.message);

  @override
  List<Object?> get props => [message];
}

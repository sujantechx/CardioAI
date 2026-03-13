import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/prediction_repository.dart';
import 'prediction_event.dart';
import 'prediction_state.dart';

class PredictionBloc extends Bloc<PredictionEvent, PredictionState> {
  final PredictionRepository _predictionRepository;

  PredictionBloc({required PredictionRepository predictionRepository})
    : _predictionRepository = predictionRepository,
      super(PredictionInitial()) {
    on<PredictionRequested>(_onPredictionRequested);
    on<PredictionReset>(_onPredictionReset);
  }

  Future<void> _onPredictionRequested(
    PredictionRequested event,
    Emitter<PredictionState> emit,
  ) async {
    emit(PredictionLoading());
    try {
      final prediction = await _predictionRepository.predict(
        event.patient, 
        event.audioBytes, 
        event.fileName,
      );
      emit(PredictionSuccess(prediction: prediction, patient: event.patient));
    } catch (e) {
      emit(PredictionError(e.toString()));
    }
  }

  void _onPredictionReset(
    PredictionReset event,
    Emitter<PredictionState> emit,
  ) {
    emit(PredictionInitial());
  }
}

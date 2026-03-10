import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/repositories/report_repository.dart';
import 'report_event.dart';
import 'report_state.dart';

class ReportBloc extends Bloc<ReportEvent, ReportState> {
  final ReportRepository _reportRepository;

  ReportBloc({required ReportRepository reportRepository})
    : _reportRepository = reportRepository,
      super(ReportInitial()) {
    on<ReportLoadHistory>(_onLoadHistory);
    on<ReportSave>(_onSave);
    on<ReportDelete>(_onDelete);
  }

  Future<void> _onLoadHistory(
    ReportLoadHistory event,
    Emitter<ReportState> emit,
  ) async {
    emit(ReportLoading());
    try {
      final reports = await _reportRepository.getHistory();
      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onSave(ReportSave event, Emitter<ReportState> emit) async {
    try {
      await _reportRepository.saveReport(event.report);
      final reports = await _reportRepository.getHistory();
      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }

  Future<void> _onDelete(ReportDelete event, Emitter<ReportState> emit) async {
    try {
      await _reportRepository.deleteReport(event.reportId);
      final reports = await _reportRepository.getHistory();
      emit(ReportLoaded(reports));
    } catch (e) {
      emit(ReportError(e.toString()));
    }
  }
}

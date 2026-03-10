import 'package:equatable/equatable.dart';
import '../../data/models/report_model.dart';

abstract class ReportEvent extends Equatable {
  const ReportEvent();

  @override
  List<Object?> get props => [];
}

class ReportLoadHistory extends ReportEvent {}

class ReportSave extends ReportEvent {
  final ReportModel report;

  const ReportSave(this.report);

  @override
  List<Object?> get props => [report];
}

class ReportDelete extends ReportEvent {
  final String reportId;

  const ReportDelete(this.reportId);

  @override
  List<Object?> get props => [reportId];
}

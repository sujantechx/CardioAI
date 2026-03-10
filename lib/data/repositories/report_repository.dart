import '../models/report_model.dart';
import '../../core/utils/dummy_data.dart';

class ReportRepository {
  final List<ReportModel> _reports = [];
  bool _initialized = false;

  Future<List<ReportModel>> getHistory() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!_initialized) {
      _reports.addAll(DummyData.generateHistory());
      _initialized = true;
    }
    return List.unmodifiable(_reports);
  }

  Future<void> saveReport(ReportModel report) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _reports.insert(0, report);
  }

  Future<void> deleteReport(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _reports.removeWhere((r) => r.id == id);
  }
}

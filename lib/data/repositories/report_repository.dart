import '../../core/database/database_helper.dart';
import '../models/patient_model.dart';
import '../models/prediction_model.dart';
import '../models/report_model.dart';

/// ═══════════════════════════════════════════════════════════
/// CardioAI — Report Repository (SQLite-backed)
/// ═══════════════════════════════════════════════════════════
///
/// Provides persistent storage for prediction history and
/// generated reports using the local SQLite database.
///
/// All data survives app restarts and is stored entirely
/// on-device (no cloud dependency required).
/// ═══════════════════════════════════════════════════════════
class ReportRepository {
  final DatabaseHelper _db = DatabaseHelper.instance;

  /// Fetch all reports from the database, newest first.
  Future<List<ReportModel>> getHistory() async {
    final rows = await _db.getAllReports();

    return rows.map((row) {
      // ── Reconstruct PatientModel ──
      final patient = PatientModel.fromJson({
        'id': row['id'],               // from patients table
        'name': row['name'] as String,
        'age': row['age'] as int,
        'gender': row['gender'] as String,
        'recordingLocation': row['recordingLocation'] as String,
        'audioFilePath': row['audioFilePath'] as String?,
        'audioFileName': row['audioFileName'] as String?,
        'recordedAt': row['recordedAt'] as String,
      });

      // ── Reconstruct PredictionModel ──
      // All prediction columns come from the JOIN
      final prediction = PredictionModel.fromJson({
        'id': row['predictionId'] ?? row['id'],
        'result': row['result'] as String,
        'confidence': row['confidence'],
        'riskLevel': row['riskLevel'] as String,
        'normalProbability': row['normalProbability'],
        'murmurProbability': row['murmurProbability'],
        'waveformData': row['waveformData'] as String,
        'spectrogramData': row['spectrogramData'] as String,
        'gradcamData': row['gradcamData'] as String,
        'featureImportance': row['featureImportance'] as String,
        'signalStats': row['signalStats'] as String,
        'predictedAt': row['predictedAt'] as String,
        'interpretation': row['interpretation'] as String?,
      });

      return ReportModel(
        id: row['reportId'] as String,
        patient: patient,
        prediction: prediction,
        generatedAt: DateTime.parse(row['reportGeneratedAt'] as String),
        pdfPath: row['reportPdfPath'] as String?,
      );
    }).toList();
  }

  /// Save a new report (patient + prediction + report metadata).
  Future<void> saveReport(ReportModel report) async {
    // Ensure patient has an ID
    final patientId = report.patient.id ??
        'pat_${DateTime.now().millisecondsSinceEpoch}';

    final patientJson = report.patient.toJson();
    patientJson['id'] = patientId;

    final predictionJson = report.prediction.toJson();

    final reportJson = {
      'id': report.id,
      'patientId': patientId,
      'predictionId': report.prediction.id,
      'generatedAt': report.generatedAt.toIso8601String(),
      'pdfPath': report.pdfPath,
    };

    await _db.insertReport(
      report: reportJson,
      patient: patientJson,
      prediction: predictionJson,
    );
  }

  /// Delete a report by its ID (cascades to patient/prediction).
  Future<void> deleteReport(String id) async {
    await _db.deleteReport(id);
  }

  /// Get total number of stored reports.
  Future<int> getReportCount() async {
    return await _db.getReportCount();
  }

  /// Clear all history (e.g. on user logout or data reset).
  Future<void> clearAll() async {
    await _db.clearAllData();
  }
}

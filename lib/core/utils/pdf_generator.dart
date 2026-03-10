import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';

class PdfGenerator {
  static Future<void> generateAndPrint({
    required PatientModel patient,
    required PredictionModel prediction,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return [
            // Header
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(20),
              decoration: pw.BoxDecoration(
                color: PdfColors.red800,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Text(
                    'CardioAI',
                    style: pw.TextStyle(
                      fontSize: 28,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.white,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'AI-Powered Heart Sound Screening Report',
                    style: const pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),

            // Report Date
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'Report ID: ${prediction.id}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
                pw.Text(
                  'Date: ${_formatDate(DateTime.now())}',
                  style: const pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 10),

            // Patient Information
            _buildSectionHeader('Patient Information'),
            pw.SizedBox(height: 8),
            _buildInfoTable([
              ['Name', patient.name],
              ['Age', '${patient.age} years'],
              ['Gender', patient.gender],
              ['Recording Location', patient.recordingLocation],
              ['Recording Date', _formatDate(patient.recordedAt)],
            ]),
            pw.SizedBox(height: 20),

            // Signal Analysis
            _buildSectionHeader('Signal Analysis'),
            pw.SizedBox(height: 8),
            _buildInfoTable([
              [
                'Duration',
                '${prediction.signalStats.duration.toStringAsFixed(1)}s',
              ],
              ['Sample Rate', '${prediction.signalStats.sampleRate} Hz'],
              ['Heart Rate', '${prediction.signalStats.heartRate} BPM'],
              [
                'SNR Before Filtering',
                '${prediction.signalStats.snrBefore.toStringAsFixed(1)} dB',
              ],
              [
                'SNR After Filtering',
                '${prediction.signalStats.snrAfter.toStringAsFixed(1)} dB',
              ],
              [
                'Mean Amplitude',
                prediction.signalStats.meanAmplitude.toStringAsFixed(4),
              ],
              [
                'Max Amplitude',
                prediction.signalStats.maxAmplitude.toStringAsFixed(4),
              ],
            ]),
            pw.SizedBox(height: 20),

            // AI Prediction Result
            _buildSectionHeader('AI Prediction Result'),
            pw.SizedBox(height: 8),
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                color: prediction.isMurmur
                    ? PdfColors.red50
                    : PdfColors.green50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(
                  color: prediction.isMurmur ? PdfColors.red : PdfColors.green,
                ),
              ),
              child: pw.Column(
                children: [
                  pw.Text(
                    prediction.result.toUpperCase(),
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: prediction.isMurmur
                          ? PdfColors.red800
                          : PdfColors.green800,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    'Confidence: ${(prediction.confidence * 100).toStringAsFixed(1)}%',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 2),
                  pw.Text(
                    'Risk Level: ${prediction.riskLevel}',
                    style: const pw.TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 12),

            _buildInfoTable([
              [
                'Normal Probability',
                '${(prediction.normalProbability * 100).toStringAsFixed(1)}%',
              ],
              [
                'Murmur Probability',
                '${(prediction.murmurProbability * 100).toStringAsFixed(1)}%',
              ],
            ]),
            pw.SizedBox(height: 20),

            // Feature Importance
            _buildSectionHeader('Feature Importance (SHAP)'),
            pw.SizedBox(height: 8),
            _buildInfoTable(
              prediction.featureImportance.entries
                  .map((e) => [e.key, e.value.toStringAsFixed(4)])
                  .toList(),
            ),
            pw.SizedBox(height: 24),

            // Medical Disclaimer
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.all(14),
              decoration: pw.BoxDecoration(
                color: PdfColors.amber50,
                borderRadius: pw.BorderRadius.circular(8),
                border: pw.Border.all(color: PdfColors.amber),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'MEDICAL DISCLAIMER',
                    style: pw.TextStyle(
                      fontSize: 12,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.amber900,
                    ),
                  ),
                  pw.SizedBox(height: 6),
                  pw.Text(
                    'This AI-generated report is for screening purposes only and is NOT a medical diagnosis. '
                    'Please consult a qualified healthcare professional (cardiologist) for proper diagnosis '
                    'and treatment. The AI prediction should be used as a supportive tool alongside clinical '
                    'examination. CardioAI and its developers are not responsible for any medical decisions '
                    'made based on this report.',
                    style: const pw.TextStyle(
                      fontSize: 9,
                      color: PdfColors.grey800,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Footer
            pw.Center(
              child: pw.Text(
                'Generated by CardioAI v1.0.0 | AI-Powered Heart Sound Screening System',
                style: const pw.TextStyle(
                  fontSize: 8,
                  color: PdfColors.grey500,
                ),
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
      name: 'CardioAI_Report_${patient.name.replaceAll(' ', '_')}.pdf',
    );
  }

  static pw.Widget _buildSectionHeader(String title) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue50,
        borderRadius: pw.BorderRadius.circular(4),
      ),
      child: pw.Text(
        title,
        style: pw.TextStyle(
          fontSize: 14,
          fontWeight: pw.FontWeight.bold,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  static pw.Widget _buildInfoTable(List<List<String>> rows) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      columnWidths: {
        0: const pw.FlexColumnWidth(2),
        1: const pw.FlexColumnWidth(3),
      },
      children: rows.map((row) {
        return pw.TableRow(
          children: [
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(
                row[0],
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.grey700,
                ),
              ),
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.all(8),
              child: pw.Text(row[1], style: const pw.TextStyle(fontSize: 10)),
            ),
          ],
        );
      }).toList(),
    );
  }

  static String _formatDate(DateTime date) {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}, '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

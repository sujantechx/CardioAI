import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../config/themes/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/gradient_card.dart';
import '../../core/utils/pdf_generator.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';
import '../../data/models/report_model.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_state.dart';
import '../../logic/report/report_bloc.dart';
import '../../logic/report/report_event.dart';

class ReportScreen extends StatelessWidget {
  final PredictionModel prediction;
  final PatientModel patient;

  const ReportScreen({
    super.key,
    required this.prediction,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
    final authState = context.read<AuthBloc>().state;
    final isGuest = authState is AuthAuthenticated && authState.user.isGuest;
    final dateFormat = DateFormat('dd MMM yyyy, hh:mm a');

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.darkGradient),
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: const Icon(
                        Icons.arrow_back_ios_rounded,
                        color: AppColors.textOnDark,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Screening Report',
                        style: GoogleFonts.outfit(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOnDark,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Report Header
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.1),
                          ),
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/app logo.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'CardioAI Report',
                                      style: GoogleFonts.outfit(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textOnDark,
                                      ),
                                    ),
                                    Text(
                                      dateFormat.format(DateTime.now()),
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.textOnDarkSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Patient Section
                      _buildSection(
                        'Patient Information',
                        Icons.person_rounded,
                        [
                          _InfoItem('Name', patient.name),
                          _InfoItem('Age', '${patient.age} years'),
                          _InfoItem('Gender', patient.gender),
                          _InfoItem(
                            'Recording Location',
                            patient.recordingLocation,
                          ),
                          _InfoItem(
                            'Date',
                            dateFormat.format(patient.recordedAt),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Signal Stats Section
                      _buildSection('Signal Analysis', Icons.graphic_eq_rounded, [
                        _InfoItem(
                          'Duration',
                          '${prediction.signalStats.duration.toStringAsFixed(1)}s',
                        ),
                        _InfoItem(
                          'Sample Rate',
                          '${prediction.signalStats.sampleRate} Hz',
                        ),
                        _InfoItem(
                          'Heart Rate',
                          '${prediction.signalStats.heartRate} BPM',
                        ),
                        _InfoItem(
                          'SNR Before',
                          '${prediction.signalStats.snrBefore.toStringAsFixed(1)} dB',
                        ),
                        _InfoItem(
                          'SNR After',
                          '${prediction.signalStats.snrAfter.toStringAsFixed(1)} dB',
                        ),
                      ]),
                      const SizedBox(height: 16),

                      // Prediction Section
                      _buildSection('AI Prediction', Icons.psychology_rounded, [
                        _InfoItem('Result', prediction.result),
                        _InfoItem(
                          'Confidence',
                          '${(prediction.confidence * 100).toStringAsFixed(1)}%',
                        ),
                        _InfoItem('Risk Level', prediction.riskLevel),
                        _InfoItem(
                          'Normal Probability',
                          '${(prediction.normalProbability * 100).toStringAsFixed(1)}%',
                        ),
                        _InfoItem(
                          'Murmur Probability',
                          '${(prediction.murmurProbability * 100).toStringAsFixed(1)}%',
                        ),
                      ]),
                      const SizedBox(height: 16),

                      // Disclaimer
                      GradientCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: AppColors.warning,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Medical Disclaimer',
                                  style: GoogleFonts.inter(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'This AI-generated report is for screening purposes only and is NOT a medical diagnosis. '
                              'Please consult a qualified healthcare professional (cardiologist) for proper diagnosis '
                              'and treatment. The AI prediction should be used as a supportive tool alongside clinical '
                              'examination.',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textOnDarkSecondary,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      if (!isGuest) ...[
                        CustomButton(
                          text: 'Download PDF Report',
                          onPressed: () => _downloadPdf(context),
                          icon: Icons.download_rounded,
                          gradient: AppColors.successGradient,
                        ),
                        const SizedBox(height: 12),
                        CustomButton(
                          text: 'Save to History',
                          isOutlined: true,
                          onPressed: () => _saveReport(context),
                          icon: Icons.save_rounded,
                        ),
                      ] else ...[
                        // Guest mode restriction
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.warning.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppColors.warning.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.lock_rounded,
                                color: AppColors.warning,
                                size: 32,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sign in to download PDF & save reports',
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  color: AppColors.warning,
                                  fontWeight: FontWeight.w500,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              CustomButton(
                                text: 'Sign In',
                                onPressed: () => context.go('/login'),
                                width: 160,
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'New Screening',
                        isOutlined: true,
                        onPressed: () => context.go('/home'),
                        icon: Icons.replay_rounded,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, IconData icon, List<_InfoItem> items) {
    return GradientCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textOnDark,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textOnDarkSecondary,
                    ),
                  ),
                  Text(
                    item.value,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textOnDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _downloadPdf(BuildContext context) async {
    try {
      await PdfGenerator.generateAndPrint(
        patient: patient,
        prediction: prediction,
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'PDF report ready!',
              style: GoogleFonts.inter(color: Colors.white),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _saveReport(BuildContext context) {
    final report = ReportModel(
      id: 'report_${DateTime.now().millisecondsSinceEpoch}',
      patient: patient,
      prediction: prediction,
      generatedAt: DateTime.now(),
    );
    context.read<ReportBloc>().add(ReportSave(report));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Report saved to history!',
          style: GoogleFonts.inter(color: Colors.white),
        ),
        backgroundColor: AppColors.success,
      ),
    );
  }
}

class _InfoItem {
  final String label;
  final String value;

  _InfoItem(this.label, this.value);
}

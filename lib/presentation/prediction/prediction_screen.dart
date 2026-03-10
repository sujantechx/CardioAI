import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/themes/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/gradient_card.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';

class PredictionScreen extends StatefulWidget {
  final PredictionModel prediction;
  final PatientModel patient;

  const PredictionScreen({
    super.key,
    required this.prediction,
    required this.patient,
  });

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..forward();

    _scaleAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pred = widget.prediction;
    final isMurmur = pred.isMurmur;

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
                        'AI Prediction',
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
                    children: [
                      // Result Card
                      ScaleTransition(
                        scale: _scaleAnim,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            gradient: isMurmur
                                ? AppColors.accentGradient
                                : AppColors.successGradient,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    (isMurmur
                                            ? AppColors.accent
                                            : AppColors.success)
                                        .withValues(alpha: 0.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                isMurmur
                                    ? Icons.warning_rounded
                                    : Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 56,
                              ),
                              const SizedBox(height: 12),
                              Text(
                                pred.result,
                                style: GoogleFonts.outfit(
                                  fontSize: 32,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                pred.riskLevel,
                                style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white.withValues(alpha: 0.85),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  'Confidence: ${(pred.confidence * 100).toStringAsFixed(1)}%',
                                  style: GoogleFonts.inter(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Probability Chart
                      GradientCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Prediction Probability',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textOnDark,
                              ),
                            ),
                            const SizedBox(height: 20),
                            SizedBox(
                              height: 200,
                              child: Row(
                                children: [
                                  // Pie chart
                                  Expanded(
                                    child: PieChart(
                                      PieChartData(
                                        sectionsSpace: 3,
                                        centerSpaceRadius: 40,
                                        sections: [
                                          PieChartSectionData(
                                            value: pred.normalProbability * 100,
                                            color: AppColors.success,
                                            title:
                                                '${(pred.normalProbability * 100).toStringAsFixed(0)}%',
                                            radius: 45,
                                            titleStyle: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          PieChartSectionData(
                                            value: pred.murmurProbability * 100,
                                            color: AppColors.accent,
                                            title:
                                                '${(pred.murmurProbability * 100).toStringAsFixed(0)}%',
                                            radius: 45,
                                            titleStyle: GoogleFonts.inter(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  // Legend
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildLegend('Normal', AppColors.success),
                                      const SizedBox(height: 12),
                                      _buildLegend('Murmur', AppColors.accent),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Patient Info
                      GradientCard(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Patient Details',
                              style: GoogleFonts.outfit(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textOnDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _buildInfoRow('Name', widget.patient.name),
                            _buildInfoRow('Age', '${widget.patient.age} years'),
                            _buildInfoRow('Gender', widget.patient.gender),
                            _buildInfoRow(
                              'Location',
                              widget.patient.recordingLocation,
                            ),
                            _buildInfoRow(
                              'Heart Rate',
                              '${pred.signalStats.heartRate} BPM',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Action Buttons
                      CustomButton(
                        text: 'View AI Explanation',
                        onPressed: () {
                          context.push(
                            '/explainability',
                            extra: {
                              'prediction': widget.prediction,
                              'patient': widget.patient,
                            },
                          );
                        },
                        icon: Icons.visibility_rounded,
                      ),
                      const SizedBox(height: 12),
                      CustomButton(
                        text: 'Generate Report',
                        isOutlined: true,
                        onPressed: () {
                          context.push(
                            '/report',
                            extra: {
                              'prediction': widget.prediction,
                              'patient': widget.patient,
                            },
                          );
                        },
                        icon: Icons.description_rounded,
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

  Widget _buildLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 13,
            color: AppColors.textOnDarkSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: AppColors.textOnDarkSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
        ],
      ),
    );
  }
}

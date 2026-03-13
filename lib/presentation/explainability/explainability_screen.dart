import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/themes/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/gradient_card.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';

class ExplainabilityScreen extends StatelessWidget {
  final PredictionModel prediction;
  final PatientModel patient;

  const ExplainabilityScreen({
    super.key,
    required this.prediction,
    required this.patient,
  });

  @override
  Widget build(BuildContext context) {
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
                        'AI Explanation',
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
                      // Grad-CAM Section
                      Text(
                        'Grad-CAM Heatmap',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOnDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Highlights spectrogram regions that influenced the AI prediction',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textOnDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Grad-CAM Visualization
                      GradientCard(
                        padding: const EdgeInsets.all(4),
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Stack(
                                children: [
                                  // Spectrogram base
                                  CustomPaint(
                                    size: const Size(double.infinity, 180),
                                    painter: _SpectrogramPainter(
                                      data: prediction.spectrogramData,
                                    ),
                                  ),
                                  // Grad-CAM overlay
                                  CustomPaint(
                                    size: const Size(double.infinity, 180),
                                    painter: _GradCAMPainter(
                                      data: prediction.gradcamData,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Heatmap legend
                      Row(
                        children: [
                          Text(
                            'Low Importance',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textOnDarkSecondary,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              height: 12,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                gradient: const LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Color(0x5500FF00),
                                    Color(0x88FFFF00),
                                    Color(0xCCFF6600),
                                    Color(0xFFFF0000),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'High Importance',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textOnDarkSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Feature Importance (SHAP)
                      Text(
                        'Feature Importance',
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textOnDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'SHAP values showing contribution of each feature',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          color: AppColors.textOnDarkSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),

                      GradientCard(
                        padding: const EdgeInsets.all(16),
                        child: SizedBox(
                          height: 300,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 0.4,
                              barTouchData: BarTouchData(
                                enabled: true,
                                touchTooltipData: BarTouchTooltipData(
                                  getTooltipColor: (_) => AppColors.surfaceDark,
                                  getTooltipItem:
                                      (group, groupIndex, rod, rodIndex) {
                                        final entries = prediction
                                            .featureImportance
                                            .entries
                                            .toList();
                                        return BarTooltipItem(
                                          '${entries[groupIndex].key}\n${entries[groupIndex].value.toStringAsFixed(3)}',
                                          GoogleFonts.inter(
                                            color: AppColors.textOnDark,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        );
                                      },
                                ),
                              ),
                              titlesData: FlTitlesData(
                                show: true,
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final entries = prediction
                                          .featureImportance
                                          .entries
                                          .toList();
                                      if (value.toInt() < entries.length) {
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            top: 8,
                                          ),
                                          child: RotatedBox(
                                            quarterTurns: 1,
                                            child: Text(
                                              entries[value.toInt()].key
                                                  .split(' ')
                                                  .first,
                                              style: GoogleFonts.inter(
                                                fontSize: 9,
                                                color: AppColors
                                                    .textOnDarkSecondary,
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                      return const Text('');
                                    },
                                    reservedSize: 60,
                                  ),
                                ),
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 32,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toStringAsFixed(1),
                                        style: GoogleFonts.inter(
                                          fontSize: 10,
                                          color: AppColors.textOnDarkSecondary,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                                rightTitles: const AxisTitles(
                                  sideTitles: SideTitles(showTitles: false),
                                ),
                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                getDrawingHorizontalLine: (value) {
                                  return FlLine(
                                    color: Colors.white.withValues(alpha: 0.05),
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: prediction.featureImportance.entries
                                  .toList()
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                    final index = entry.key;
                                    final value = entry.value.value;
                                    return BarChartGroupData(
                                      x: index,
                                      barRods: [
                                        BarChartRodData(
                                          toY: value,
                                          width: 16,
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(4),
                                              ),
                                          gradient: LinearGradient(
                                            colors: [
                                              AppColors.primary,
                                              AppColors.primary.withValues(
                                                alpha: 0.6,
                                              ),
                                            ],
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                          ),
                                        ),
                                      ],
                                    );
                                  })
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Interpretation
                      GradientCard(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.lightbulb_rounded,
                                  color: AppColors.warning,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'AI Interpretation',
                                  style: GoogleFonts.outfit(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textOnDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Text(
                              prediction.interpretation,
                              style: GoogleFonts.inter(
                                fontSize: 13,
                                color: AppColors.textOnDarkSecondary,
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      CustomButton(
                        text: 'Generate Report',
                        onPressed: () {
                          context.push(
                            '/report',
                            extra: {
                              'prediction': prediction,
                              'patient': patient,
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
}

class _SpectrogramPainter extends CustomPainter {
  final List<List<double>> data;

  _SpectrogramPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final rows = data.length;
    if (rows == 0) return;
    final cols = data[0].length;

    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final value = data[i][j].clamp(0.0, 1.0);
        final gray = (value * 255).toInt();
        final color = Color.fromARGB(255, gray ~/ 3, gray ~/ 3, gray ~/ 2);
        final rect = Rect.fromLTWH(
          j * cellWidth,
          i * cellHeight,
          cellWidth + 1,
          cellHeight + 1,
        );
        canvas.drawRect(rect, Paint()..color = color);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _GradCAMPainter extends CustomPainter {
  final List<List<double>> data;

  _GradCAMPainter({required this.data});

  @override
  void paint(Canvas canvas, Size size) {
    final rows = data.length;
    if (rows == 0) return;
    final cols = data[0].length;

    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    for (int i = 0; i < rows; i++) {
      for (int j = 0; j < cols; j++) {
        final value = data[i][j].clamp(0.0, 1.0);
        if (value > 0.2) {
          Color color;
          if (value < 0.4) {
            color = Color.lerp(
              Colors.transparent,
              Colors.green.withValues(alpha: 0.3),
              (value - 0.2) / 0.2,
            )!;
          } else if (value < 0.6) {
            color = Color.lerp(
              Colors.green.withValues(alpha: 0.3),
              Colors.yellow.withValues(alpha: 0.5),
              (value - 0.4) / 0.2,
            )!;
          } else if (value < 0.8) {
            color = Color.lerp(
              Colors.yellow.withValues(alpha: 0.5),
              Colors.orange.withValues(alpha: 0.6),
              (value - 0.6) / 0.2,
            )!;
          } else {
            color = Color.lerp(
              Colors.orange.withValues(alpha: 0.6),
              Colors.red.withValues(alpha: 0.7),
              (value - 0.8) / 0.2,
            )!;
          }
          final rect = Rect.fromLTWH(
            j * cellWidth,
            i * cellHeight,
            cellWidth + 1,
            cellHeight + 1,
          );
          canvas.drawRect(rect, Paint()..color = color);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

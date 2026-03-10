import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../config/themes/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/gradient_card.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';

class SignalVisualizationScreen extends StatefulWidget {
  final PredictionModel prediction;
  final PatientModel patient;

  const SignalVisualizationScreen({
    super.key,
    required this.prediction,
    required this.patient,
  });

  @override
  State<SignalVisualizationScreen> createState() =>
      _SignalVisualizationScreenState();
}

class _SignalVisualizationScreenState extends State<SignalVisualizationScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
                        'Signal Analysis',
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

              // Tab Bar
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicator: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  indicatorSize: TabBarIndicatorSize.tab,
                  dividerColor: Colors.transparent,
                  labelColor: Colors.white,
                  unselectedLabelColor: AppColors.textOnDarkSecondary,
                  labelStyle: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                  tabs: const [
                    Tab(text: 'Waveform'),
                    Tab(text: 'Spectrogram'),
                    Tab(text: 'Stats'),
                  ],
                ),
              ),

              // Content
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildWaveformTab(),
                    _buildSpectrogramTab(),
                    _buildStatsTab(),
                  ],
                ),
              ),

              // Continue Button
              Padding(
                padding: const EdgeInsets.all(20),
                child: CustomButton(
                  text: 'View Prediction',
                  onPressed: () {
                    context.push(
                      '/prediction',
                      extra: {
                        'prediction': widget.prediction,
                        'patient': widget.patient,
                      },
                    );
                  },
                  icon: Icons.arrow_forward_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaveformTab() {
    final data = widget.prediction.waveformData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Raw Waveform',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Heart sound signal amplitude over time',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textOnDarkSecondary,
            ),
          ),
          const SizedBox(height: 16),
          GradientCard(
            padding: const EdgeInsets.all(16),
            height: 200,
            child: LineChart(
              LineChartData(
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
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .where((e) => e.key % 3 == 0)
                        .map((e) => FlSpot(e.key.toDouble(), e.value))
                        .toList(),
                    isCurved: true,
                    color: AppColors.accent,
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.accent.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Filtered Signal',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'After bandpass filter (20-500 Hz)',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textOnDarkSecondary,
            ),
          ),
          const SizedBox(height: 16),
          GradientCard(
            padding: const EdgeInsets.all(16),
            height: 200,
            child: LineChart(
              LineChartData(
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
                titlesData: const FlTitlesData(show: false),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: data
                        .asMap()
                        .entries
                        .where((e) => e.key % 3 == 0)
                        .map((e) => FlSpot(e.key.toDouble(), e.value * 0.9))
                        .toList(),
                    isCurved: true,
                    color: AppColors.success,
                    barWidth: 1.5,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.success.withValues(alpha: 0.1),
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

  Widget _buildSpectrogramTab() {
    final specData = widget.prediction.spectrogramData;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mel Spectrogram',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Frequency representation of the heart sound',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textOnDarkSecondary,
            ),
          ),
          const SizedBox(height: 16),
          GradientCard(
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: _SpectrogramPainter(data: specData),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Color scale
          Row(
            children: [
              Text(
                'Low',
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
                        Color(0xFF000033),
                        Color(0xFF0000FF),
                        Color(0xFF00FFFF),
                        Color(0xFF00FF00),
                        Color(0xFFFFFF00),
                        Color(0xFFFF0000),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'High',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.textOnDarkSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Frequency (Hz) vs Time (s)',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: AppColors.textOnDarkSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsTab() {
    final stats = widget.prediction.signalStats;
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Signal Statistics',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: 16),
          _buildStatRow(
            'Duration',
            '${stats.duration.toStringAsFixed(1)}s',
            Icons.timer_outlined,
          ),
          _buildStatRow(
            'Sample Rate',
            '${stats.sampleRate} Hz',
            Icons.graphic_eq_rounded,
          ),
          _buildStatRow(
            'Heart Rate',
            '${stats.heartRate} BPM',
            Icons.favorite_rounded,
          ),
          _buildStatRow(
            'Mean Amplitude',
            stats.meanAmplitude.toStringAsFixed(3),
            Icons.show_chart_rounded,
          ),
          _buildStatRow(
            'Max Amplitude',
            stats.maxAmplitude.toStringAsFixed(3),
            Icons.trending_up_rounded,
          ),

          const SizedBox(height: 24),
          Text(
            'SNR Improvement',
            style: GoogleFonts.outfit(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textOnDark,
            ),
          ),
          const SizedBox(height: 16),
          GradientCard(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSnrBox(
                      'Before',
                      '${stats.snrBefore.toStringAsFixed(1)} dB',
                      AppColors.warning,
                    ),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.textOnDarkSecondary,
                    ),
                    _buildSnrBox(
                      'After',
                      '${stats.snrAfter.toStringAsFixed(1)} dB',
                      AppColors.success,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: stats.snrAfter / (stats.snrBefore + stats.snrAfter),
                    backgroundColor: AppColors.warning.withValues(alpha: 0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.success,
                    ),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${((stats.snrAfter - stats.snrBefore) / stats.snrBefore * 100).toStringAsFixed(0)}% improvement',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GradientCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primary, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textOnDarkSecondary,
              ),
            ),
            const Spacer(),
            Text(
              value,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textOnDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSnrBox(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textOnDarkSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ),
      ],
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
        final color = _getSpectrogramColor(value);
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

  Color _getSpectrogramColor(double value) {
    if (value < 0.2) {
      return Color.lerp(
        const Color(0xFF000033),
        const Color(0xFF0000FF),
        value / 0.2,
      )!;
    } else if (value < 0.4) {
      return Color.lerp(
        const Color(0xFF0000FF),
        const Color(0xFF00FFFF),
        (value - 0.2) / 0.2,
      )!;
    } else if (value < 0.6) {
      return Color.lerp(
        const Color(0xFF00FFFF),
        const Color(0xFF00FF00),
        (value - 0.4) / 0.2,
      )!;
    } else if (value < 0.8) {
      return Color.lerp(
        const Color(0xFF00FF00),
        const Color(0xFFFFFF00),
        (value - 0.6) / 0.2,
      )!;
    } else {
      return Color.lerp(
        const Color(0xFFFFFF00),
        const Color(0xFFFF0000),
        (value - 0.8) / 0.2,
      )!;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

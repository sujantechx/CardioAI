import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../config/themes/app_colors.dart';
import '../../core/widgets/custom_button.dart';
import '../../data/repositories/auth_repository.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingData> _pages = [
    _OnboardingData(
      icon: Icons.mic_rounded,
      title: 'Record Heart Sound',
      description:
          'Record or upload heart sounds using a digital stethoscope. Our system accepts standard .wav audio files for analysis.',
      gradient: AppColors.accentGradient,
      iconColor: AppColors.accent,
    ),
    _OnboardingData(
      icon: Icons.auto_graph_rounded,
      title: 'AI Analysis',
      description:
          'Advanced AI processes your audio through signal processing, spectrogram generation, and deep learning classification.',
      gradient: AppColors.primaryGradient,
      iconColor: AppColors.primary,
    ),
    _OnboardingData(
      icon: Icons.insights_rounded,
      title: 'Explainable Results',
      description:
          'Get clear predictions with confidence scores, Grad-CAM heatmaps, and detailed explanations doctors can trust.',
      gradient: AppColors.successGradient,
      iconColor: AppColors.success,
    ),
    _OnboardingData(
      icon: Icons.picture_as_pdf_rounded,
      title: 'Generate Reports',
      description:
          'Download comprehensive PDF reports with patient info, signal analysis, AI predictions, and medical disclaimers.',
      gradient: const LinearGradient(
        colors: [Color(0xFF8B5CF6), Color(0xFFA78BFA)],
      ),
      iconColor: const Color(0xFF8B5CF6),
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
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
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: TextButton(
                  onPressed: _onComplete,
                  child: Text(
                    'Skip',
                    style: GoogleFonts.inter(
                      color: AppColors.textOnDarkSecondary,
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Page View
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (index) {
                    setState(() => _currentPage = index);
                  },
                  itemBuilder: (context, index) {
                    return _OnboardingPage(data: _pages[index]);
                  },
                ),
              ),
              // Indicator + Button
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: ExpandingDotsEffect(
                        dotColor: Colors.white.withValues(alpha: 0.2),
                        activeDotColor: AppColors.primary,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                        spacing: 6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    CustomButton(
                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          _onComplete();
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        }
                      },
                      icon: _currentPage == _pages.length - 1
                          ? Icons.arrow_forward_rounded
                          : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onComplete() async {
    await context.read<AuthRepository>().setFirstLaunchDone();
    if (mounted) context.go('/login');
  }
}

class _OnboardingData {
  final IconData icon;
  final String title;
  final String description;
  final Gradient gradient;
  final Color iconColor;

  _OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
    required this.gradient,
    required this.iconColor,
  });
}

class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;

  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon with gradient background
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: data.gradient,
              boxShadow: [
                BoxShadow(
                  color: data.iconColor.withValues(alpha: 0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Icon(data.icon, size: 64, color: Colors.white),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.textOnDark,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: AppColors.textOnDarkSecondary,
              height: 1.6,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

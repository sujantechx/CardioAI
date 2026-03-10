import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../config/themes/app_colors.dart';
import '../../logic/auth/auth_bloc.dart';
import '../../logic/auth/auth_event.dart';
import '../../logic/auth/auth_state.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _heartController;
  late AnimationController _fadeController;
  late AnimationController _ecgController;
  late Animation<double> _heartScale;
  late Animation<double> _fadeIn;
  late Animation<double> _ecgAnimation;

  @override
  void initState() {
    super.initState();

    _heartController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _ecgController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _heartScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _heartController, curve: Curves.elasticOut),
    );

    _fadeIn = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _fadeController, curve: Curves.easeIn));

    _ecgAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _ecgController, curve: Curves.easeInOut));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _heartController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _fadeController.forward();
    _ecgController.forward();
    await Future.delayed(const Duration(milliseconds: 1500));

    if (mounted) {
      context.read<AuthBloc>().add(AuthCheckStatus());
    }
  }

  @override
  void dispose() {
    _heartController.dispose();
    _fadeController.dispose();
    _ecgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthFirstLaunch) {
          context.go('/onboarding');
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        } else if (state is AuthUnauthenticated) {
          context.go('/login');
        }
      },
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(gradient: AppColors.darkGradient),
          child: Stack(
            children: [
              // Background ECG line
              AnimatedBuilder(
                animation: _ecgAnimation,
                builder: (context, child) {
                  return CustomPaint(
                    size: MediaQuery.of(context).size,
                    painter: _ECGBackgroundPainter(
                      progress: _ecgAnimation.value,
                    ),
                  );
                },
              ),
              // Main content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Animated App Logo
                    AnimatedBuilder(
                      animation: _heartScale,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _heartScale.value,
                          child: Container(
                            width: 160,
                            height: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(
                                    alpha: 0.4,
                                  ),
                                  blurRadius: 40,
                                  spreadRadius: 8,
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Image.asset(
                                'assets/app logo.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 32),
                    // App Name
                    FadeTransition(
                      opacity: _fadeIn,
                      child: Column(
                        children: [
                          Text(
                            'CardioAI',
                            style: GoogleFonts.outfit(
                              fontSize: 42,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              letterSpacing: -1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ShaderMask(
                            shaderCallback: (bounds) =>
                                AppColors.primaryGradient.createShader(bounds),
                            child: Text(
                              'AI-Powered Heart Sound Screening',
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                letterSpacing: 1.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Version at bottom
              Positioned(
                bottom: 40,
                left: 0,
                right: 0,
                child: FadeTransition(
                  opacity: _fadeIn,
                  child: Text(
                    'v1.0.0',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      color: AppColors.textOnDarkSecondary.withValues(
                        alpha: 0.5,
                      ),
                      fontSize: 12,
                    ),
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

class _ECGBackgroundPainter extends CustomPainter {
  final double progress;

  _ECGBackgroundPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final w = size.width;
    final h = size.height / 2;

    for (int line = 0; line < 3; line++) {
      final yOffset = h - 80 + line * 80;
      path.moveTo(0, yOffset);

      for (double x = 0; x < w * progress; x += 2) {
        double normalizedX = (x / w) * 8;
        double y = yOffset;

        // Create ECG-like pattern
        double phase = normalizedX + line * 2;
        double segment = phase % 2.0;

        if (segment > 0.8 && segment < 0.9) {
          y = yOffset - 20;
        } else if (segment > 0.9 && segment < 0.95) {
          y = yOffset + 40;
        } else if (segment > 0.95 && segment < 1.0) {
          y = yOffset - 30;
        } else if (segment > 1.0 && segment < 1.1) {
          y = yOffset + 10;
        }

        path.lineTo(x, y);
      }
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ECGBackgroundPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

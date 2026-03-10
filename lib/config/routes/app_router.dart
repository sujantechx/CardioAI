import 'package:go_router/go_router.dart';
import '../../data/models/patient_model.dart';
import '../../data/models/prediction_model.dart';
import '../../presentation/splash/splash_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/auth/register_screen.dart';
import '../../presentation/home/home_screen.dart';
import '../../presentation/upload/upload_screen.dart';
import '../../presentation/signal/signal_visualization_screen.dart';
import '../../presentation/prediction/prediction_screen.dart';
import '../../presentation/explainability/explainability_screen.dart';
import '../../presentation/report/report_screen.dart';
import '../../presentation/history/history_screen.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(
        path: '/upload',
        builder: (context, state) => const UploadScreen(),
      ),
      GoRoute(
        path: '/signal',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return SignalVisualizationScreen(
            prediction: extra['prediction'] as PredictionModel,
            patient: extra['patient'] as PatientModel,
          );
        },
      ),
      GoRoute(
        path: '/prediction',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return PredictionScreen(
            prediction: extra['prediction'] as PredictionModel,
            patient: extra['patient'] as PatientModel,
          );
        },
      ),
      GoRoute(
        path: '/explainability',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ExplainabilityScreen(
            prediction: extra['prediction'] as PredictionModel,
            patient: extra['patient'] as PatientModel,
          );
        },
      ),
      GoRoute(
        path: '/report',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          return ReportScreen(
            prediction: extra['prediction'] as PredictionModel,
            patient: extra['patient'] as PatientModel,
          );
        },
      ),
      GoRoute(
        path: '/history',
        builder: (context, state) => const HistoryScreen(),
      ),
    ],
  );
}

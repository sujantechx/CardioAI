import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'config/routes/app_router.dart';
import 'config/themes/app_theme.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/prediction_repository.dart';
import 'data/repositories/report_repository.dart';
import 'logic/auth/auth_bloc.dart';
import 'logic/prediction/prediction_bloc.dart';
import 'logic/report/report_bloc.dart';

class CardioAIApp extends StatelessWidget {
  const CardioAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final authRepository = AuthRepository();
    final predictionRepository = PredictionRepository();
    final reportRepository = ReportRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(create: (_) => authRepository),
        RepositoryProvider<PredictionRepository>(
          create: (_) => predictionRepository,
        ),
        RepositoryProvider<ReportRepository>(create: (_) => reportRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (_) => AuthBloc(authRepository: authRepository),
          ),
          BlocProvider<PredictionBloc>(
            create: (_) =>
                PredictionBloc(predictionRepository: predictionRepository),
          ),
          BlocProvider<ReportBloc>(
            create: (_) => ReportBloc(reportRepository: reportRepository),
          ),
        ],
        child: MaterialApp.router(
          title: 'CardioAI',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
          routerConfig: AppRouter.router,
        ),
      ),
    );
  }
}

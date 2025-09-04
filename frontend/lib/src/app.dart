import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'core/services/service_locator.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/curriculum/presentation/bloc/curriculum_bloc.dart';
import 'features/content/presentation/bloc/content_bloc.dart';
import 'features/profile/presentation/bloc/profile_bloc.dart';

class GyanAIApp extends StatelessWidget {
  const GyanAIApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authService: ServiceLocator.authService,
          ),
        ),
        BlocProvider(
          create: (context) => CurriculumBloc(
            curriculumService: ServiceLocator.curriculumService,
          ),
        ),
        BlocProvider(
          create: (context) => ContentBloc(
            contentService: ServiceLocator.contentService,
          ),
        ),
        BlocProvider(
          create: (context) => ProfileBloc(
            profileService: ServiceLocator.profileService,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Gyan AI',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
      ),
    );
  }
}

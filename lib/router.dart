import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_boilerplate/core/constants/named_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/features/features.dart';
import 'package:flutter_boilerplate/features/auth/auth.dart';
import 'package:flutter_boilerplate/locator.dart';

final router = GoRouter(
  initialLocation: NamedRoutes.initial,
  routes: [
    // Login
    GoRoute(
      path: NamedRoutes.login,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthBloc>(),
        child: const LoginPage(),
      ),
    ),

    // Profile
    GoRoute(
      path: NamedRoutes.profile,
      builder: (context, state) => BlocProvider(
        create: (_) => getIt<AuthBloc>()..add(const AuthCheckRequested()),
        child: const ProfilePage(),
      ),
    ),

    // Settings
    GoRoute(
      path: NamedRoutes.settings,
      builder: (context, state) => const AppSettingsPage(),
    ),

    // Default route
    GoRoute(
      path: NamedRoutes.initial,
      redirect: (context, state) => NamedRoutes.login,
    ),
  ],
);

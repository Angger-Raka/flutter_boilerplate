import 'package:flutter_boilerplate/core/constants/named_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_boilerplate/features/features.dart';

final router = GoRouter(
  initialLocation: NamedRoutes.initial,

  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AppSettingsPage(),
    ),
  ],
);

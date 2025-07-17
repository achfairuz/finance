// lib/core/routes/app_routes.dart

import 'package:finance/UI/Transaction/formTransaction.dart';
import 'package:finance/UI/auth/auth.dart';
import 'package:finance/UI/components/navbar.dart';
import 'package:finance/UI/onBoarding/onBoarding.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String login = '/';
  static const String register = '/register';
  static const String dashboard = '/dashboard';
  static const String navbar = '/navbar';
  static const String formTransaction = '/form-transaction';
  static const String onboarding = '/onboarding';
  static const String formUpdateProfile = '/form-update/profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const onBoarding1());
      case login:
        return MaterialPageRoute(
          builder: (_) => const Auth(initialTab: 1),
        );

      case register:
        return MaterialPageRoute(
          builder: (_) => const Auth(initialTab: 2),
        );

      case dashboard:
      case navbar:
        return MaterialPageRoute(
          builder: (_) => const Navbar(),
        );

      case formTransaction:
        final args = settings.arguments as Map<String, dynamic>? ?? {};
        final String select = args['select'] ?? 'pengeluaran';
        final String action = args['action'] ?? 'create';
        final int? id = args['id'];

        return MaterialPageRoute(
          builder: (_) => FormTransaction(
            select: select,
            action: action,
            id: id,
          ),
        );
      case formUpdateProfile:
      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('404 - Route tidak ditemukan')),
          ),
        );
    }
  }
}

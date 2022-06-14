import 'package:flutter/material.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_page.dart';

class Routes {
  static const main = '/';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.main:
      return MaterialPageRoute(
          builder: (context) => const AuthPage(), settings: settings);
    default:
      throw Exception('Undefined route');
  }
}

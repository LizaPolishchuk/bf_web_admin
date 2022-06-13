import 'package:flutter/material.dart';
import 'package:salons_adminka/prezentation/main_container.dart';

class Routes {
  static const main = '/';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.main:
      return MaterialPageRoute(
          builder: (context) => const MainContainer(), settings: settings);
    default:
      throw Exception('Undefined route');
  }
}

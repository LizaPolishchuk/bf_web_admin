import 'package:flutter/material.dart';
import 'package:salons_adminka/prezentation/home_page.dart';
import 'package:salons_adminka/prezentation/salon_details_page.dart';

class Routes {
  static const home = '/';
  static const salonDetails = '/salon-details';
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.home:
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => HomePage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        settings: settings
      );
    case Routes.salonDetails:
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => SalonDetailsPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    default:
      throw Exception('Undefined route');
  }
}

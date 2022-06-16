import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:salons_adminka/prezentation/salon_details_page.dart';
import 'package:salons_adminka/prezentation/services_page/services_page.dart';

import '../prezentation/home_page.dart';

class Routes {
  static const initial = '*';
  static const home = '/';
  static const salonDetails = '/salon-details';
  static const services = '/services';
}

BeamerDelegate routeDelegate = BeamerDelegate(
  initialPath: Routes.home,
  transitionDelegate: const NoAnimationTransitionDelegate(),
  locationBuilder: RoutesLocationBuilder(
    routes: {
      Routes.home: (context, state, data) => const HomePage(),
      Routes.salonDetails: (context, state, data) {
        print("go to open salon details");
        return  SalonDetailsPage();
        // return const BeamPage(
        //     key: ValueKey('salon-details'),
        //     child: SalonDetailsPage());
      },
      Routes.services: (context, state, data) => const ServicesPage(),
    },
  ),
);

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.home:
      return MaterialPageRoute(
          builder: (context) => const HomePage(), settings: settings);
    case Routes.salonDetails:
      return PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) =>
            const SalonDetailsPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      );
    default:
      throw Exception('Undefined route');
  }
}

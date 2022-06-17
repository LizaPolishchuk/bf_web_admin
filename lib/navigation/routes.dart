import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:salons_adminka/prezentation/home_page.dart';
import 'package:salons_adminka/prezentation/salon_details_page.dart';

class Routes {
  static const home = '/';
  static const salonDetails = '/salon-details';
}

class RouterSingleton {
  static GoRouter? _router;

  static get router => _router ?? createGoRouter();

  static GoRouter createGoRouter() {
    print("createGoRouter : $createGoRouter");
    _router = GoRouter(
      initialLocation: Routes.home,
      routes: <GoRoute>[
        GoRoute(
          path: Routes.home,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const HomePage(),
          ),
        ),
        GoRoute(
          path: Routes.salonDetails,
          pageBuilder: (context, state) => NoTransitionPage<void>(
            key: state.pageKey,
            child: const SalonDetailsPage(),
          ),
        ),
      ],
    );

    return _router!;
  }
}

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.home:
      return PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => HomePage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
          settings: settings);
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

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:salons_adminka/prezentation/home_container.dart';

class HomeContainerLocation extends BeamLocation<BeamState> {
  HomeContainerLocation(RouteInformation routeInformation)
      : super(routeInformation);

  @override
  List<String> get pathPatterns => ['/*'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: ValueKey('home-${DateTime.now()}'),
          title: 'Home',
          child: const HomeContainer(),
        )
      ];
}

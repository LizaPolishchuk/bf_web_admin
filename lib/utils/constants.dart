
//flutter run lib/main.dart --dart-define=host="backend_host" --dart-define=port="backend_port"

import 'package:responsive_builder/responsive_builder.dart';

abstract class Constants {
  static const String host = String.fromEnvironment(
    'host',
    defaultValue: '',
  );

  static const String port = String.fromEnvironment(
    'port',
    defaultValue: '',
  );


  static const ScreenBreakpoints clientDetailsScreenBreakpoints = ScreenBreakpoints(tablet: 600, desktop: 1200, watch: 300);

  static const double drawerBigWidth = 264;
  static const double drawerSmallWidth = 68;
}

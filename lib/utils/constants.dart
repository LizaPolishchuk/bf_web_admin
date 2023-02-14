
//flutter run lib/main.dart --dart-define=host="backend_host" --dart-define=port="backend_port"

abstract class Constants {
  static const String host = String.fromEnvironment(
    'host',
    defaultValue: '',
  );

  static const String port = String.fromEnvironment(
    'port',
    defaultValue: '',
  );
}

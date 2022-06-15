import 'package:get_it/get_it.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';

final getItWeb = GetIt.instance;

Future<void> init() async {
  ///Bloc
  getItWeb.registerFactory(
      () => AuthBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
}

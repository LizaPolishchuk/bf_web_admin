import 'package:get_it/get_it.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_adminka/prezentation/categories/categories_bloc.dart';
import 'package:salons_adminka/prezentation/masters_page/masters_bloc.dart';
import 'package:salons_adminka/prezentation/profile_page/profile_bloc.dart';
import 'package:salons_adminka/prezentation/services_page/services_bloc.dart';

final getItWeb = GetIt.instance;

Future<void> init() async {
  ///Bloc
  getItWeb.registerFactory(() => AuthBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ProfileBloc(getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => CategoriesBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ServicesBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => MastersBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
}

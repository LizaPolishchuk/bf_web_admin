import 'package:bf_web_admin/prezentation/calendar_page/appointments_bloc.dart';
import 'package:bf_web_admin/prezentation/feedbacks_page/feedbacks_bloc.dart';
import 'package:bf_web_admin/prezentation/masters_page/masters_bloc.dart';
import 'package:bf_web_admin/prezentation/profile_page/profile_bloc.dart';
import 'package:bf_web_admin/prezentation/profile_page/search_places/places_bloc.dart';
import 'package:bf_web_admin/prezentation/promo_and_bonus_cards/promo/promos_bloc.dart';
import 'package:bf_web_admin/prezentation/services_page/services_bloc.dart';
import 'package:get_it/get_it.dart';

final getItWeb = GetIt.instance;

Future<void> init() async {
  ///Bloc
  // getItWeb.registerFactory(() => AuthBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ProfileBloc(getItWeb()));
  // getItWeb.registerFactory(() => CategoriesBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ServicesBloc(getItWeb()));
  getItWeb.registerFactory(() => MastersBloc(getItWeb()));
  // getItWeb.registerFactory(() => ClientsBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => PromosBloc(getItWeb()));
  // getItWeb.registerFactory(() => SettingsBloc(getItWeb()));
  getItWeb.registerFactory(() => FeedbacksBloc());
  getItWeb.registerFactory(() => AppointmentsBloc(getItWeb()));
  getItWeb.registerFactory(() => PlacesBloc(getItWeb()));
}

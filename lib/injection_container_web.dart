import 'package:get_it/get_it.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_adminka/prezentation/calendar_page/orders_bloc.dart';
import 'package:salons_adminka/prezentation/categories/categories_bloc.dart';
import 'package:salons_adminka/prezentation/clients_page/clients_bloc.dart';
import 'package:salons_adminka/prezentation/feedbacks_page/feedbacks_bloc.dart';
import 'package:salons_adminka/prezentation/masters_page/masters_bloc.dart';
import 'package:salons_adminka/prezentation/profile_page/profile_bloc.dart';
import 'package:salons_adminka/prezentation/profile_page/search_places/places_bloc.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/bonus_cards_bloc.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promos_bloc.dart';
import 'package:salons_adminka/prezentation/services_page/services_bloc.dart';
import 'package:salons_adminka/prezentation/settings_page/settings_bloc.dart';

final getItWeb = GetIt.instance;

Future<void> init() async {
  ///Bloc
  getItWeb.registerFactory(() => AuthBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ProfileBloc(getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => CategoriesBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ServicesBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => MastersBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => ClientsBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => PromosBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => BonusCardsBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => SettingsBloc(getItWeb()));
  getItWeb.registerFactory(() => FeedbacksBloc());
  getItWeb.registerFactory(() => OrdersBloc(getItWeb(), getItWeb(), getItWeb(), getItWeb()));
  getItWeb.registerFactory(() => PlacesBloc(getItWeb(), getItWeb()));
}

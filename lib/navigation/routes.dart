import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:salons_adminka/main.dart';
import 'package:salons_adminka/prezentation/calendar_page/calendar_page.dart';
import 'package:salons_adminka/prezentation/feedbacks_page/feedbacks_page.dart';
import 'package:salons_adminka/prezentation/home_container.dart';
import 'package:salons_adminka/prezentation/loader_page.dart';
import 'package:salons_adminka/prezentation/masters_page/masters_page.dart';
import 'package:salons_adminka/prezentation/profile_page/profile_page.dart';
import 'package:salons_adminka/prezentation/promo_and_bonus_cards/promo_and_cards_page.dart';
import 'package:salons_adminka/prezentation/settings_page/settings_page.dart';
import 'package:salons_adminka/prezentation/support_page/support_page.dart';

import '../prezentation/services_page/services_page.dart';

const int homeIndex = 0;
const int servicesIndex = 1;
const int mastersIndex = 2;
const int clientsIndex = 3;
const int promosIndex = 4;
const int feedbacksIndex = 5;
const int profileIndex = 6;
const int supportIndex = 7;
const int settingsIndex = 8;

class Routes {
  static const initial = '/';
  static const profile = '/profile';
  static const services = '/services';
  static const masters = '/masters';
  static const clients = '/clients';
  static const clientEdit = '/client/edit';
  static const promos = '/promos';
  static const feedbacks = '/feedbacks';
  static const support = '/support';
  static const settings = '/settings';
  static const calendar = '/calendar';
  static const loader = '/loader';
}

abstract class AppPages {
  static final pages = [
    GetPage(
      name: Routes.initial,
      page: () => const InitialPage(),
    ),
    GetPage(
      name: Routes.services,
      page: () => const HomeContainer(
        selectedMenuIndex: servicesIndex,
        child: ServicesPage(),
      ),
    ),
    GetPage(
      name: Routes.masters,
      page: () => const HomeContainer(
        selectedMenuIndex: mastersIndex,
        child: MastersPage(),
      ),
    ),
    GetPage(
      name: Routes.clients,
      page: () => const HomeContainer(
        selectedMenuIndex: clientsIndex,
        child: ClientsPage(),
      ),
    ),
    // GetPage(
    //   name: Routes.clientEdit,
    //   page: () =>  HomeContainer(
    //     selectedMenuIndex: clientsIndex,
    //     child: ClientDetailsPage(),
    //   ),
    // ),
    GetPage(
      name: Routes.promos,
      page: () => const HomeContainer(
        selectedMenuIndex: promosIndex,
        child: PromosPage(),
      ),
    ),
    GetPage(
      name: Routes.feedbacks,
      page: () => const HomeContainer(
        selectedMenuIndex: feedbacksIndex,
        child: FeedbacksPage(),
      ),
    ),
    GetPage(
      name: Routes.profile,
      page: () => const HomeContainer(
        selectedMenuIndex: profileIndex,
        child: ProfilePage(),
      ),
    ),
    GetPage(
      name: Routes.support,
      page: () => const HomeContainer(
        selectedMenuIndex: supportIndex,
        child: SupportPage(),
      ),
    ),
    GetPage(
      name: Routes.settings,
      page: () => const HomeContainer(
        selectedMenuIndex: settingsIndex,
        child: SettingsPage(),
      ),
    ),
    GetPage(
      name: Routes.calendar,
      page: () => const HomeContainer(
        selectedMenuIndex: homeIndex,
        child: CalendarPage(),
      ),
    ),
    GetPage(
      name: Routes.loader,
      opaque: false,
      page: () => const Loader(),
    ),
  ];
}

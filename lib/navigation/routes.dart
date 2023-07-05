import 'package:bf_web_admin/main.dart';
import 'package:bf_web_admin/prezentation/home_container.dart';
import 'package:bf_web_admin/utils/page_content_type.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

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
    ), ..._createPagesForTabs(),

    // GetPage(
    //   name: Routes.clients,
    //   page: () => const HomeContainer(
    //     selectedMenuIndex: clientsIndex,
    //     child: ClientsPage(),
    //   ),
    // ),
    // GetPage(
    //   name: Routes.clientEdit,
    //   page: () =>  HomeContainer(
    //     selectedMenuIndex: clientsIndex,
    //     child: ClientDetailsPage(),
    //   ),
    // ),
    // GetPage(
    //   name: Routes.support,
    //   page: () => const HomeContainer(
    //     selectedMenuIndex: supportIndex,
    //     child: SupportPage(),
    //   ),
    // ),
    // GetPage(
    //   name: Routes.loader,
    //   opaque: false,
    //   page: () => const Loader(),
    // ),
  ];

  static List<GetPage> _createPagesForTabs() {
    return PageContentType.values
        .map(
          (pageType) => GetPage(
            name: "/${pageType.name}",
            page: () => HomeContainer(currentPageType: pageType),
          ),
        )
        .toList();
  }
}

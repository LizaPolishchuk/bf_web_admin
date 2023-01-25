import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
// ignore_for_file: depend_on_referenced_packages
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salons_adminka/event_bus_events/user_success_logged_in_event.dart';
import 'package:salons_adminka/l10n/l10n.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_page.dart';
import 'package:salons_adminka/prezentation/home_container.dart';
import 'package:salons_adminka/prezentation/home_page/home_page.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart' as di;
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'event_bus_events/event_bus.dart';
import 'event_bus_events/user_logout_event.dart';
import 'injection_container_web.dart' as webdi;
import 'navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Paint.enableDithering = true;

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD1iuXsP1pCry9jNdG0l-5Meyu7dJUp3CI",
        appId: "1:883762712602:web:5629380a6e16d74d8641a3",
        messagingSenderId: "883762712602",
        projectId: "salons-5012c",
        authDomain: "salons-5012c.firebaseapp.com",
        storageBucket: "salons-5012c.appspot.com",
        measurementId: "G-HQ1FC3TVZX"),
  );

  await di.init();
  await webdi.init();

  await initHive();

  runApp(const MyApp());
}

Future<void> initHive() async {
  await Hive.initFlutter();

  Hive.registerAdapter(SalonAdapter());
  Hive.registerAdapter(MasterAdapter());
  Hive.registerAdapter(ServiceAdapter());
  Hive.registerAdapter(OrderEntityAdapter());
  Hive.registerAdapter(UserEntityAdapter());
  Hive.registerAdapter(CategoryAdapter());

  await getIt<LocalStorage>().openBox();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // Get.changeTheme(Get.isDarkMode? ThemeData.light(): ThemeData.dark());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: Hive.box(LocalStorage.preferencesBox).listenable(),
        builder: (BuildContext context, Box<dynamic> box, Widget? child) {
          final isLight = box.get(LocalStorage.themeMode, defaultValue: true);
          return GetMaterialApp.router(
            debugShowCheckedModeBanner: false,
            defaultTransition: Transition.noTransition,
            getPages: AppPages.pages,
            routerDelegate: Get.rootDelegate,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            // themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
            themeMode: ThemeMode.dark,
            title: 'B&F Admin Panel',
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!,
            ),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: L10n.all,
          );
        });
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String? token;
  String? salonId;
  late Widget _initialPage;

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getIt<LocalStorage>();
    salonId = localStorage.getSalonId();
    token = localStorage.getAccessToken();

    if (kDebugMode) {
      print("Main: salonId: $salonId, token: $token");
    }

    eventBus.on<UserSuccessLoggedInEvent>().listen((event) {
      setState(() {
        _initialPage = const HomeContainer(
          selectedMenuIndex: homeIndex,
          child: HomePage(),
        );
      });
    });
    eventBus.on<UserLoggedOutEvent>().listen((event) {
      setState(() {
        _initialPage = const AuthPage();
      });
    });

    _initialPage =
        token != null ? const HomeContainer(selectedMenuIndex: homeIndex, child: HomePage()) : const AuthPage();

    if (token != null && salonId == null) {
      token = null;
      getIt<AuthBloc>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initialPage;
  }
}

import 'package:bf_web_admin/event_bus_events/user_success_logged_in_event.dart';
import 'package:bf_web_admin/l10n/l10n.dart';
import 'package:bf_web_admin/prezentation/home_container.dart';
import 'package:bf_web_admin/prezentation/home_page/home_page.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart' as di;
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';
import 'package:universal_io/io.dart';

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

  // Hive.registerAdapter(SalonAdapter());
  // Hive.registerAdapter(MasterAdapter());
  // Hive.registerAdapter(ServiceAdapter());
  // Hive.registerAdapter(OrderEntityAdapter());
  // Hive.registerAdapter(UserEntityAdapter());
  // Hive.registerAdapter(CategoryAdapter());

  await getIt<LocalStorage>().openBox();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<BoxEvent>(
        stream: Hive.box(LocalStorage.preferencesBox).watch(key: LocalStorage.themeMode),
        builder: (context, snapshot) {
          bool isLight = snapshot.data?.value ?? getIt<LocalStorage>().getThemeMode ?? true;

          return StreamBuilder<BoxEvent>(
              stream: Hive.box(LocalStorage.preferencesBox).watch(key: LocalStorage.currentLanguage),
              builder: (context, snapshot) {
                final String defaultSystemLocale = Platform.localeName;
                Locale locale = Locale(
                  snapshot.data?.value ?? getIt<LocalStorage>().getLanguage() ?? defaultSystemLocale,
                );
                debugPrint("defaultSystemLocale: $defaultSystemLocale, currentLanguage: $locale");

                if (Get.locale != locale) {
                  Get.locale = locale;
                  ErrorParser().updateLocale(locale);
                }

                return GetMaterialApp.router(
                  debugShowCheckedModeBanner: false,
                  defaultTransition: Transition.noTransition,
                  getPages: AppPages.pages,
                  routerDelegate: Get.rootDelegate,
                  theme: AppTheme.light,
                  darkTheme: AppTheme.dark,
                  // locale: _locale,
                  themeMode: isLight ? ThemeMode.light : ThemeMode.dark,
                  title: 'B&F Admin Panel',
                  builder: (context, child) => MediaQuery(
                    data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
                    child: child!,
                  ),
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    LocaleNamesLocalizationsDelegate(),
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: L10n.supportedLocales,
                );
              });
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
      // setState(() {
      //   _initialPage = const AuthPage();
      // });
    });

    _initialPage = const HomeContainer(selectedMenuIndex: homeIndex, child: HomePage());
    // token != null ? const HomeContainer(selectedMenuIndex: homeIndex, child: HomePage()) : const AuthPage();

    if (token != null && salonId == null) {
      token = null;
      // getIt<AuthBloc>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _initialPage;
  }
}

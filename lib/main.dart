import 'package:bf_network_module/bf_network_module.dart' as di;
import 'package:bf_network_module/bf_network_module.dart';
import 'package:bf_web_admin/event_bus_events/event_bus.dart';
import 'package:bf_web_admin/event_bus_events/salon_created_event.dart';
import 'package:bf_web_admin/l10n/l10n.dart';
import 'package:bf_web_admin/prezentation/auth_page/auth_page.dart';
import 'package:bf_web_admin/prezentation/create_salon/create_salon_page.dart';
import 'package:bf_web_admin/prezentation/home_container.dart';
import 'package:bf_web_admin/prezentation/home_page/initial_bloc.dart';
import 'package:bf_web_admin/utils/app_theme.dart';
import 'package:bf_web_admin/utils/error_parser.dart';
import 'package:bf_web_admin/utils/page_content_type.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_localized_locales/flutter_localized_locales.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:universal_io/io.dart';

import 'injection_container_web.dart' as webdi;
import 'navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Paint.enableDithering = true;

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDxsQ7ofwJ7f4pRqlzAkui2ErcJR6t-GPY",
        appId: "1:269566824654:web:860f009f6d3acb8d1f409f",
        messagingSenderId: "269566824654",
        projectId: "bfree-web",
        authDomain: "bfree-web.firebaseapp.com",
        storageBucket: "bfree-web.appspot.com",
        measurementId: "G-8JXG8CJK8K"),
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
  final ValueNotifier<Widget?> _initialPageValue = ValueNotifier(null);

  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    _initDynamicLinks();

    FirebaseAuth.instance.authStateChanges().listen((event) {
      print("authStateChanges: $event");

      if (event == null) {
        _initialPageValue.value = const AuthPage();
      }
      // else if (!event.emailVerified) {
      //   _initialPageValue.value = const VerifyEmailPage();
      // }
      else {
        _initialPageValue.value = _initialWidget();
      }
    });

    eventBus.on<SalonCreatedEvent>().listen((event) {
      _initialPageValue.value = const HomeContainer(currentPageType: PageContentType.home);
    });
  }

  void _initDynamicLinks() {
    dynamicLinks.onLink.listen((dynamicLinkData) async {
      //Get actionCode from the dynamicLink
      final Uri deepLink = dynamicLinkData.link;
      var actionCode = deepLink.queryParameters['oobCode'];

      print("actionCode from dynamic link is $actionCode");

      if (actionCode != null) {
        try {
          await auth.checkActionCode(actionCode);
          await auth.applyActionCode(actionCode);

          // If successful, reload the user:
          auth.currentUser?.reload();
        } on FirebaseAuthException catch (e) {
          if (e.code == 'invalid-action-code') {
            print('The code is invalid.');
          }
        }
      }
    }).onError((error) {
      print('onLink error');
      print(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Widget?>(
      valueListenable: _initialPageValue,
      builder: (context, page, child) {
        return page ??
            Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
      },
    );

    // StreamBuilder<User?>(
    //   stream: FirebaseAuth.instance.authStateChanges(),
    //   builder: (context, snapshot) {
    //     print("authStateChanges: ${snapshot.data}");
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(
    //         child: CircularProgressIndicator(
    //           color: Theme.of(context).primaryColor,
    //         ),
    //       );
    //     } else if (snapshot.data != null) {
    //       print("User: ${snapshot.data}");
    //
    //       bool isEmailVerified = snapshot.data!.emailVerified;
    //       print("isEmailVerified: $isEmailVerified");
    //
    //       // if (!isEmailVerified) {
    //       //   return const VerifyEmailPage();
    //       // }
    //
    //       return _initialWidget();
    //
    //       if (getIt<LocalStorage>().getSalonId() == null) {
    //         return const CreateSalonPage();
    //       }
    //
    //       return const HomeContainer(selectedMenuIndex: homeIndex, child: HomePage());
    //     } else {
    //       return const AuthPage();
    //     }
    //   },
    // );
  }

  Widget _initialWidget() {
    InitialBloc initialBloc = getIt<InitialBloc>();

    return FutureBuilder(
        future: initialBloc.checkIfSalonExists(),
        builder: (context, snapshot) {
          print("is salon exists: ${snapshot.data}");
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).primaryColor,
              ),
            );
          }
          if (snapshot.data == true) {
            return const HomeContainer(currentPageType: PageContentType.home);
          } else {
            return const CreateSalonPage();
          }
        });
  }
}

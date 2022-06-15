import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:salons_adminka/event_bus_events/user_success_logged_in_event.dart';
import 'package:salons_adminka/navigation/routes.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_bloc.dart';
import 'package:salons_adminka/prezentation/auth_page/auth_page.dart';
import 'package:salons_adminka/prezentation/main_container.dart';
import 'package:salons_adminka/utils/app_theme.dart';
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart' as di;
import 'package:salons_app_flutter_module/salons_app_flutter_module.dart';

import 'event_bus_events/event_bus.dart';
import 'event_bus_events/user_logout_event.dart';
import 'injection_container_web.dart' as webDi;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD1iuXsP1pCry9jNdG0l-5Meyu7dJUp3CI",
      appId: "1:883762712602:web:5629380a6e16d74d8641a3",
      messagingSenderId: "883762712602",
      projectId: "salons-5012c",
      authDomain: "salons-5012c.firebaseapp.com",
      storageBucket: "salons-5012c.appspot.com",
      measurementId: "G-HQ1FC3TVZX"
    ),
  );

  await di.init();
  await webDi.init();

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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: AppTheme.light,
      dark: AppTheme.dark,
      initial: AdaptiveThemeMode.light,
      builder: (light, dark) => MaterialApp(
        theme: light,
        darkTheme: dark,
        debugShowCheckedModeBanner: false,
        title: 'Salons Admin Panel UI',
        initialRoute: Routes.main,
        onGenerateRoute: onGenerateRoute,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ru', 'RU'),
        ],
        home: const InitialPage(),
      ),
    );
  }
}

class InitialPage extends StatefulWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  State<InitialPage> createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  String? token;
  Salon? salon;
  late Widget _initialPage;

  @override
  void initState() {
    super.initState();

    LocalStorage localStorage = getIt<LocalStorage>();
    salon = localStorage.getSalon();
    token = localStorage.getAccessToken();

    print("Main: salon: $salon, token: $token");

    eventBus.on<UserSuccessLoggedInEvent>().listen((event) {
      setState(() {
        _initialPage = const MainContainer();
      });
    });
    eventBus.on<UserLoggedOutEvent>().listen((event) {
      setState(() {
        _initialPage = const AuthPage();
      });
    });

    _initialPage = token != null ? const MainContainer() : const AuthPage();

    if (token != null && salon == null) {
      token = null;
      getIt<AuthBloc>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _initialPage);
  }
}

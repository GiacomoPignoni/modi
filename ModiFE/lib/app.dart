import 'package:easy_localization/easy_localization.dart';
import 'package:easy_logger/easy_logger.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:modi/life_cycle.dart';
import 'package:modi/localization.dart';
import 'package:modi/models/config.dart';
import 'package:modi/pages/calendar/calendar_page.dart';
import 'package:modi/pages/edit-profile/edit_profile_page.dart';
import 'package:modi/pages/home/home_page.dart';
import 'package:modi/pages/info/info_page.dart';
import 'package:modi/pages/initial_loading/initial_loading_page.dart';
import 'package:modi/pages/login/login_page.dart';
import 'package:modi/pages/partner/partner_page.dart';
import 'package:modi/pages/read-notes/read_notes_page.dart';
import 'package:modi/pages/reset_password/reset_password_page.dart';
import 'package:modi/pages/shop/shop_page.dart';
import 'package:modi/pages/sign_up/sign_up_page.dart';
import 'package:modi/pages/tutorial/tutorial_page.dart';
import 'package:modi/services/ad_service.dart';
import 'package:modi/services/analytics_service.dart';
import 'package:modi/services/config_service.dart';
import 'package:modi/services/http_service.dart';
import 'package:modi/services/message_service.dart';
import 'package:modi/services/navigation_service.dart';
import 'package:modi/services/notes_service.dart';
import 'package:modi/services/notification_service.dart';
import 'package:modi/services/shop_service.dart';
import 'package:modi/services/user_service.dart';
import 'package:modi/theme/light_theme.dart';
import 'package:flutter/services.dart';

Future<void> startApp(LocalConfig localConfig) async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();

  FirebaseMessaging.onBackgroundMessage(NotificationService.firebaseMessagingBackgroundHandler);

  // Set only portrait mode
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
  );

  EasyLocalization.logger.enableLevels = (localConfig.env == Env.dev) ? [LevelMessages.error, LevelMessages.warning] : [];
  
  final configSvc = ConfigService(localConfig);
  GetIt.I.registerSingleton(configSvc);

  final analyticsSvc = AnalyticsService();
  GetIt.I.registerSingleton(analyticsSvc);
  final adSvc = AdService();
  GetIt.I.registerSingleton(adSvc);

  GetIt.I.registerSingleton(NavigationService());
  GetIt.I.registerSingleton(MessageService());
  GetIt.I.registerSingleton(HttpService());

  final notificationSvc = NotificationService()..init();
  GetIt.I.registerSingleton(notificationSvc);

  final userSvc = UserService();
  GetIt.I.registerSingleton(userSvc);

  GetIt.I.registerLazySingleton(() => NotesService());
  GetIt.I.registerLazySingleton(() => ShopService());

  await configSvc.init();
  final List<Future<void>> futures = [
    adSvc.init(),
    userSvc.init(),
    Future.delayed(const Duration(milliseconds: 1000))
  ];
  final Future<void> generalFutureToAwait = Future.wait(futures);

  analyticsSvc.I.logAppOpen();

  runApp(LifeCycle(
    child: Localization(
      child: MyApp(
        futureToAwait: generalFutureToAwait
      ),
    ),
  ));
}

class MyApp extends StatelessWidget {
  final NavigationService navigatorSvc = GetIt.I.get<NavigationService>();
  final MessageService messageSvc = GetIt.I.get<MessageService>();
  final UserService userSvc = GetIt.I.get<UserService>();
  final AnalyticsService analyticsSvc = GetIt.I.get<AnalyticsService>();
  final ConfigService configSvc = GetIt.I.get<ConfigService>();

  final Future<void> futureToAwait;

  MyApp({
    required this.futureToAwait,
    Key? key
  }) : super(key: key);

  final routes = {
    LoginPage.routePath: (_) => const LoginPage(),
    SignUpPage.routePath: (_) => const SignUpPage(),
    ResetPasswordPage.routePath: (_) => const ResetPasswordPage(),
    HomePage.routePath: (_) => const HomePage(),
    CalendarPage.routePath: (_) => const CalendarPage(),
    EditProfilePage.routePath: (_) => const EditProfilePage(),
    ReadNotesPage.routePath: (_) => const ReadNotesPage(),
    PartnerPage.routePath: (_) => const PartnerPage(),
    ShopPage.routePath: (_) => const ShopPage(),
    InfoPage.routePath: (_) => const InfoPage(),
    TutorialPage.routePath: (_) => const TutorialPage()
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: lightTheme,
      routes: routes,
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: analyticsSvc.I),
      ],
      debugShowCheckedModeBanner: configSvc.env == Env.dev,
      navigatorKey: GetIt.I.get<NavigationService>().navigatorKey,
      scaffoldMessengerKey: GetIt.I.get<MessageService>().scaffoldMessangerKey,
      home: InitialLoadingPage(
        futureToAwait: futureToAwait,
        nextRoute: (userSvc.isLogged) ? HomePage.routePath : LoginPage.routePath,
      )
    );
  }
}

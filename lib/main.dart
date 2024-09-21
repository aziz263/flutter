import 'dart:io';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sagem/screens/Unit%C3%A9DeStock.dart/Uscreen.dart';
import 'History/history_screen.dart';
import 'screens/Magasin/magasin_screen.dart';
import 'screens/Magasinier_funct/magasinier_screen.dart';
import 'screens/article_funct.dart/article_screen.dart';
import 'screens/authentification/notification.dart';
import 'screens/authentification/sign_up_form.dart';
import 'screens/detailpicklist_funct/alldetailpicklists.dart';
import 'screens/entryPoint/entry_point.dart';
import 'screens/home/home_screen.dart';
import 'screens/ligne_de_production/ligne_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/picklist_funct/picklistscreen.dart';
import 'screens/profile/profile.dart';

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await AwesomeNotifications().initialize(
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic Notification',
        channelDescription: 'Basic notifications channel',
      ),
    ],
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic Group',
      ),
    ],
  );

  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'The Flutter Way',
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => const EntryPoint(
              selected: 0,
              content: HomePage(),
            ),
        '/picklist': (context) => const PicklistPage(),
        '/detailpicklist': (context) => const DetailPicklistsView(),
        '/magasinier': (context) => const MagasiniersView(),
        '/magasin': (context) => const MagasinsView(),
        '/onboarding': (context) => const OnboardingScreen(
              child: SignUpForm(),
            ),
        '/profile': (context) =>
            const EntryPoint(content: Profile(), selected: 1),
        '/history': (context) => const EntryPoint(
              selected: 3,
              content: HistoriqueScreen(),
            ),
        '/article': (context) => const ArticlesView(),
        '/us': (context) => const UsView(),
        '/ligne': (context) => const LigneView(),
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(foregroundColor: Colors.white),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      home: const OnboardingScreen(
        child: SignUpForm(),
      ),
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);

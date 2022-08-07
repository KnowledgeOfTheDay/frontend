import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'components/app_settings.dart';
import 'firebase_options.dart';
import 'helpers/authentication_factory.dart';
import 'screens/knowledge_detail_screen.dart';
import 'theming/dark_theme.dart';
import 'theming/light_theme.dart';
import 'package:provider/provider.dart';

import 'package:workmanager/workmanager.dart';

import 'helpers/rest_helper.dart';
import 'models/knowledges.dart';
import 'screens/home_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
  // ToDo: if in creation screen, ask if the user wants to leave and then open the knowledge detail view.
  print(message.notification?.body);
}

void callbackDispatcher() async {
  Workmanager().executeTask((taskName, inputData) async {
    print("Native called background task: $inputData");

    try {
      return await RestHelper.registerDevice() ?? true;
    } catch (error) {
      debugPrint(error.toString());
    }
    return false;
  });
}

Future<void> main() async {
  await Settings.init();
  RestHelper.initialize();
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  // AwesomeNotifications().initialize(
  //     // set the icon to null if you want to use the default app icon
  //     null,
  //     [
  //       NotificationChannel(
  //           channelGroupKey: 'basic_channel_group',
  //           channelKey: 'basic_channel',
  //           channelName: 'Basic notifications',
  //           channelDescription: 'Notification channel for basic tests',
  //           defaultColor: Color(0xFF9D50DD),
  //           ledColor: Colors.white)
  //     ],
  //     // Channel groups are only visual and are not required
  //     channelGroups: [NotificationChannelGroup(channelGroupkey: 'basic_channel_group', channelGroupName: 'Basic group')],
  //     debug: true);

  FirebaseMessaging.onMessage.listen(firebaseMessagingForegroundHandler);
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);
  Workmanager().registerPeriodicTask(
    "kotd-register-device",
    "register-device",
    frequency: const Duration(days: 14),
    constraints: Constraints(networkType: NetworkType.connected, requiresBatteryNotLow: true),
  );

  runApp(const KnowledgeOfTheDay());
}

class KnowledgeOfTheDay extends StatelessWidget {
  const KnowledgeOfTheDay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthenticationFactory.getOrCreate(),
        ),
        ChangeNotifierProxyProvider<FlutterAuth, Knowledges>(
          create: (_) => Knowledges(null, []),
          update: (ctx, auth, previousKnowledges) => Knowledges(
            auth,
            previousKnowledges?.items ?? [],
          ),
        ),
      ],
      child: Consumer<FlutterAuth>(
        builder: (context, auth, _) => MaterialApp(
          title: "Erkenntnis des Tages",
          theme: LightTheme.get(),
          darkTheme: DarkTheme.get(),
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale("de"),
            Locale("en"),
          ],
          localizationsDelegates: const [
            FormBuilderLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: const HomeScreen(),
          routes: {
            KnowledgeDetailScreen.routeName: (_) => const KnowledgeDetailScreen(),
            AppSettings.routeName: (_) => const AppSettings(),
          },
        ),
      ),
    );
  }
}

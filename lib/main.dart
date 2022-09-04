import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:kotd/models/categories.dart';
import 'package:kotd/screens/filtered_list_screen.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'components/app_settings.dart';
import 'helpers/authentication_factory.dart';
import 'screens/knowledge_detail_screen.dart';
import 'theming/dark_theme.dart';
import 'theming/light_theme.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'helpers/rest_helper.dart';
import 'models/knowledges.dart';
import 'screens/home_screen.dart';

// Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   await Firebase.initializeApp();
// }

// Future<void> firebaseMessagingForegroundHandler(RemoteMessage message) async {
//   // ToDo: if in creation screen, ask if the user wants to leave and then open the knowledge detail view.
// }

// void callbackDispatcher() async {
//   Workmanager().executeTask((taskName, inputData) async {
//     try {
//       return await RestHelper.registerDevice() ?? true;
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//     return false;
//   });
// }

Future<void> main() async {
  await SentryFlutter.init((options) {
    options.dsn = 'https://f9ba3d5319cc410398be25d01b1c70e3@o1394801.ingest.sentry.io/6717038';
    options.tracesSampleRate = 1.0;
  }, appRunner: () async {
    await Settings.init();
    RestHelper.initialize();
    WidgetsFlutterBinding.ensureInitialized();

    FlutterError.onError = (details) async {
      if (kReleaseMode) await Sentry.captureException(details.exception, stackTrace: details.stack);
    };

    runApp(const KnowledgeOfTheDay());
  });
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
        ChangeNotifierProxyProvider<FlutterAuth, Categories>(
          create: (_) => Categories(null, []),
          update: (ctx, auth, previouseCategories) => Categories(
            auth,
            previouseCategories?.items ?? [],
          ),
        ),
      ],
      child: Consumer<FlutterAuth>(
        builder: (context, auth, _) => MaterialApp(
          onGenerateTitle: (ctx) => AppLocalizations.of(ctx)!.appTitle,
          theme: LightTheme.get(),
          darkTheme: DarkTheme.get(),
          debugShowCheckedModeBanner: false,
          supportedLocales: const [
            Locale("de"),
            Locale("en"),
          ],
          localizationsDelegates: const [
            AppLocalizations.delegate,
            FormBuilderLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          home: const HomeScreen(),
          routes: {
            KnowledgeDetailScreen.routeName: (_) => const KnowledgeDetailScreen(),
            AppSettings.routeName: (_) => const AppSettings(),
            FilteredListScreen.routeName: (_) => const FilteredListScreen(),
          },
        ),
      ),
    );
  }
}

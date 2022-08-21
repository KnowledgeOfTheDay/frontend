import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import '../components/app_drawer.dart';
import '../components/knowledge_speed_dial.dart';
import '../helpers/knowledge_type.dart';
import '../helpers/modal_helper.dart';
import '../helpers/settings_key.dart';
import '../models/url_knowledge.dart';
import 'knowledge_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/login.dart';
import '../models/knowledges.dart';
import '../components/knowledges_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _intentDataStreamSubscription;
  bool shouldLoadList = true;

  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (null != initialMessage) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'kotd') {
      Navigator.pushNamed(context, KnowledgeDetailScreen.routeName, arguments: message);
    }
  }

  Future<void> _handleSharedData(String sharedData) async {
    setState(() {
      shouldLoadList = false;
    });

    if (sharedData.isNotEmpty && Provider.of<FlutterAuth>(context, listen: false).isLoggedIn) {
      if (Settings.getValue<bool>(SettingsKey.useFastCreation, defaultValue: false)!) {
        if (await Provider.of<Knowledges>(context, listen: false).addUrl(UrlKnowledge.local(sharedData), shouldNotify: false)) {
          await SystemNavigator.pop();
        }
      } else {
        ModalHelper.showEditModal(context, KnowledgeType.url, initialValues: {"url": sharedData});
      }
    }

    ReceiveSharingIntent.reset();

    setState(() {
      shouldLoadList = true;
    });
  }

  Widget? getFloatingActionButton() {
    return Provider.of<FlutterAuth>(context, listen: false).isLoggedIn ? const KnowledgeSpeedDial() : null;
    // return FloatingActionButton(child: const Icon(Icons.add), onPressed: () => ModalHelper.showEditModal(context, KnowledgeType.url));
  }

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
    FirebaseMessaging.onMessage.listen(_handleMessage);

    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      _handleSharedData(value);
    }, onDone: () {
      ReceiveSharingIntent.reset();
    });

    ReceiveSharingIntent.getInitialText().then((String? value) {
      if (null != value) {
        _handleSharedData(value);
      }
    });
  }

  @override
  void dispose() {
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appTitle),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<FlutterAuth>(context).loginRequired,
          builder: (ctx, snapshot) {
            if (snapshot.hasData && shouldLoadList) {
              return snapshot.data as bool ? const Login() : const KnowledgesList();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: getFloatingActionButton(),
    );
  }
}

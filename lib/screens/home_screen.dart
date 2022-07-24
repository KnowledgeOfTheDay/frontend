import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth/flutter_auth.dart';
import 'package:kotd/components/app_drawer.dart';
import 'package:kotd/screens/knowledge_detail_screen.dart';
import 'package:provider/provider.dart';

import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../components/login.dart';
import '../models/knowledges.dart';
import 'knowledge_creation_screen.dart';
import '../components/knowledges_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription? _intentDataStreamSubscription;

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

  void _handleSharedData(String sharedData) {
    if (sharedData.isNotEmpty) {
      Provider.of<Knowledges>(context, listen: false).add(sharedData);
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      // Navigator.pushNamed(context, KnowledgeCreationScreen.routeName, arguments: sharedData);
    }
  }

  @override
  void initState() {
    super.initState();

    setupInteractedMessage();
    FirebaseMessaging.onMessage.listen(_handleMessage);

    _intentDataStreamSubscription = ReceiveSharingIntent.getTextStream().listen((String value) {
      _handleSharedData(value);
    }, onError: (err) {
      print("getLinkStream error: $err");
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
        title: const Text("Knowledge of the day"),
      ),
      drawer: const AppDrawer(),
      body: FutureBuilder(
          future: Provider.of<FlutterAuth>(context).loginRequired,
          builder: (ctx, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data as bool ? const Login() : const KnowledgesList();
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
      floatingActionButton: Provider.of<FlutterAuth>(context).isLoggedIn
          ? FloatingActionButton(
              onPressed: () => Navigator.pushNamed(context, KnowledgeCreationScreen.routeName),
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}

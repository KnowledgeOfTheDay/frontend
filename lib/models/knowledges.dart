import 'dart:convert';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';

import 'package:kotd/helpers/rest_helper.dart';

import 'knowledge.dart';

class Knowledges with ChangeNotifier {
  final FlutterAuth? _auth;

  List<Knowledge> _items = [];

  List<Knowledge> get items {
    return _items.where((element) => !(element.isUsed ?? false)).toList();
  }

  Knowledges(this._auth, this._items);

  Future<bool> fetchKnowledges() async {
    List<Knowledge> items = [];
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge");

    final response = await _auth!.get(url);
    bool success = 400 >= response.statusCode;
    if (success && 200 == response.statusCode) {
      final body = json.decode(response.body);
      items = List<Knowledge>.from(body.map((model) => Knowledge.fromJson(model)));

      _items = items;
      notifyListeners();
    }

    return success;
  }

  Future<bool> add(String link, {bool shouldNotify = true}) async {
    Knowledge? knowledge;
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge");

    Map<String, String> headers = {
      "content-type": "application/json",
    };

    final response = await _auth!.post(url, body: jsonEncode({"url": link}), headers: headers);
    bool success = false;
    if (response.statusCode == 200) {
      try {
        final body = jsonDecode(response.body);
        knowledge = Knowledge(body["id"], link, false);
        _items.add(knowledge);

        if (shouldNotify) notifyListeners();
        success = true;
      } catch (error) {
        // AwesomeNotifications()
        //     .createNotification(content: NotificationContent(id: 1, channelKey: "basic_channel", title: "an error occured.", body: error.toString()));
      }
    }

    return success;
  }

  Future<void> setIsUsed(String id) async {
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge/$id/done");
    Knowledge knowledge = _items.firstWhere((element) => element.id == id);
    final isUsed = knowledge.isUsed;
    knowledge.isUsed = true;
    notifyListeners();

    Map<String, String> headers = {
      "content-type": "application/json",
    };

    final response = await _auth!.post(url, headers: headers);

    if (response.statusCode >= 400) {
      knowledge.isUsed = isUsed;
      notifyListeners();
      throw "Could not update knowledge.";
    }
  }

  Future<void> delete(String id) async {
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge/$id");
    final index = _items.indexWhere((element) => element.id == id);
    Knowledge? knowledge = _items[index];

    _items.removeAt(index);
    notifyListeners();

    final response = await _auth!.delete(url);

    if (response.statusCode >= 400) {
      _items.insert(index, knowledge);
      notifyListeners();
      throw "Could not delete the knowledge.";
    }
  }
}

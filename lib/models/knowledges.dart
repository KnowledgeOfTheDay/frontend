import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';

import '../helpers/rest_helper.dart';

import 'knowledge.dart';

class Knowledges with ChangeNotifier {
  final FlutterAuth? _auth;

  List<Knowledge> _items = [];

  List<Knowledge> get items {
    return [..._items];
  }

  Knowledges(this._auth, this._items);

  Future<bool> _add(Knowledge knowledge, Uri url, {bool shouldNotify = true}) async {
    Map<String, String> headers = {
      "content-type": "application/json",
    };

    final response = await _auth!.post(url, body: jsonEncode(knowledge), headers: headers);
    bool success = false;
    if (response.statusCode == 200) {
      try {
        final body = jsonDecode(response.body);
        knowledge = Knowledge.fromJson(body);
        // knowledge.id = body["id"];
        // knowledge.isUsed = false;

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

  Future<bool> add(Knowledge knowledge, {bool shouldNotify = true}) async {
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge");

    return await _add(knowledge, url, shouldNotify: shouldNotify);
  }

  Future<void> setIsUsed(String id, bool hasWon) async {
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge/$id/done");
    Knowledge knowledge = _items.firstWhere((element) => element.id == id);
    final isUsed = knowledge.isUsed;
    final currentWonState = knowledge.hasWon;
    knowledge.isUsed = true;
    knowledge.hasWon = hasWon;
    notifyListeners();

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await _auth!.post(url, body: jsonEncode({"hasWon": hasWon}), headers: headers);

    if (response.statusCode >= 400) {
      knowledge.isUsed = isUsed;
      knowledge.hasWon = currentWonState;
      notifyListeners();
      throw "Could not update knowledge.";
    }
  }

  Future<bool> update(String id, Knowledge item) async {
    final url = Uri.https(RestHelper.baseUrl, "/api/Knowledge/$id");

    Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final response = await _auth!.put(url, body: jsonEncode(item.toJson()), headers: headers);

    bool success = 400 >= response.statusCode;
    if (success && 200 == response.statusCode) {
      try {
        final body = json.decode(response.body);
        _items.removeWhere((element) => element.id == id);
        _items.add(Knowledge.fromJson(body));
        notifyListeners();
        success = true;
      } catch (error) {}
    }

    return success;
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

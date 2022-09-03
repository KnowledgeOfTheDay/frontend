import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_auth/flutter_auth.dart';

import '../helpers/rest_helper.dart';
import 'category.dart';

class Categories with ChangeNotifier {
  final FlutterAuth? _auth;

  List<Category> _items = [];

  List<Category> get items {
    return [..._items];
  }

  Categories(this._auth, this._items);

  Future<bool> fetchCategories() async {
    List<Category> items = [];
    final url = Uri.https(RestHelper.baseUrl, "/api/Category");

    final response = await _auth!.get(url);
    bool success = 400 >= response.statusCode;
    if (success && 200 == response.statusCode) {
      final body = json.decode(response.body);
      items = List<Category>.from(body.map((model) => Category.fromJson(model)));

      _items = items;
      notifyListeners();
    }
    return true;
  }

  Future<bool> add(Category category) async {
    final url = Uri.https(RestHelper.baseUrl, "/api/Category");

    Map<String, String> headers = {
      "content-type": "application/json",
    };

    _items.add(category);

    final response = await _auth!.post(url, body: jsonEncode(category), headers: headers);
    bool success = false;
    if (response.statusCode == 200) {
      try {
        final body = jsonDecode(response.body);
        final category = Category.fromJson(body);

        _items.add(category);

        notifyListeners();
        success = true;
      } catch (error) {}
    } else {
      _items.remove(category);
    }

    return success;
  }
}

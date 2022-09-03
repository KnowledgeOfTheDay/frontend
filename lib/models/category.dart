import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Category with ChangeNotifier {
  String name;

  Category(this.name);

  Map<String, dynamic> toJson() => {"name": name};

  static Category fromJson(Map<String, dynamic> data) => Category(data["name"]);
}

import 'package:flutter/widgets.dart';

import 'category.dart';

class Knowledge with ChangeNotifier {
  String? id;
  String? url;
  String? title;
  String? description;
  String? imageUrl;
  int priority;
  bool isUsed;
  bool? hasWon;
  DateTime lastUpdate;
  DateTime createdAt;
  List<Category> categories;

  Knowledge(
    this.id, {
    this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.priority = 5,
    this.isUsed = false,
    this.hasWon,
    required this.lastUpdate,
    required this.createdAt,
    this.categories = const [],
  });

  Knowledge.local(this.url)
      : priority = 5,
        isUsed = false,
        lastUpdate = DateTime.now(),
        createdAt = DateTime.now(),
        categories = const [];

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "priority": priority,
        "isUsed": isUsed,
        "hasWon": hasWon,
        "lastUpdate": lastUpdate.toString(),
        "createdAt": createdAt.toString(),
        "categories": categories,
      };

  static Knowledge fromJson(Map<String, dynamic> data) {
    final map = data["categories"];
    final List<Category> categories = null == map
        ? []
        : map is List<Category>
            ? map
            : List<Category>.from(map.map((model) => Category.fromJson(model)));

    return Knowledge(data["id"],
        url: data["url"],
        title: data["title"],
        description: data["description"],
        imageUrl: data["imageUrl"],
        priority: data["priority"] ?? 5,
        isUsed: data["isUsed"] ?? false,
        hasWon: data["hasWon"],
        createdAt: null != data["createdAt"] ? DateTime.parse(data["createdAt"]) : DateTime(1970),
        lastUpdate: null != data["lastUpdate"] ? DateTime.parse(data["lastUpdate"]) : DateTime(1970),
        categories: categories);
  }
}

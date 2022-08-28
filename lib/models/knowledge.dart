import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class Knowledge with ChangeNotifier {
  String? id;
  String? url;
  String? title;
  String? description;
  String? imageUrl;
  int priority;
  bool isUsed;
  bool? hasWon;
  DateTime? lastUpdate;

  Knowledge(
    this.id, {
    this.url,
    this.title,
    this.description,
    this.imageUrl,
    this.priority = 5,
    this.isUsed = false,
    this.hasWon,
    this.lastUpdate,
  });

  Knowledge.local(this.url)
      : priority = 5,
        isUsed = false;

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "title": title,
        "description": description,
        "imageUrl": imageUrl,
        "priority": priority,
        "isUsed": isUsed,
        "hasWon": hasWon,
        "lastUpdate": lastUpdate
      };

  static Knowledge fromJson(Map<String, dynamic> data) => Knowledge(data["id"],
      url: data["url"],
      title: data["title"],
      description: data["description"],
      imageUrl: data["imageUrl"],
      priority: data["priority"] ?? 5,
      isUsed: data["isUsed"] ?? false,
      hasWon: data["hasWon"],
      lastUpdate: data["lastUpdate"]);
}

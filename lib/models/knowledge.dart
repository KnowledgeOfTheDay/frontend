import 'package:flutter/foundation.dart';

class Knowledge with ChangeNotifier {
  final String id;
  final String url;
  bool? isUsed;

  Knowledge(
    this.id,
    this.url,
    this.isUsed,
  );

  Map toJson() => {
        "id": id,
        "url": url,
        "isUsed": isUsed,
      };

  static Knowledge fromJson(Map<String, dynamic> data) => Knowledge(
        data["id"],
        data["url"],
        data["isUsed"],
      );
}

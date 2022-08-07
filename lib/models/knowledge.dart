import 'package:flutter/foundation.dart';

class Knowledge with ChangeNotifier {
  String? id;
  bool? isUsed;

  Knowledge(
    this.id,
    this.isUsed,
  );

  Map toJson() => {
        "id": id,
        "isUsed": isUsed,
      };

  static Knowledge fromJson(Map<String, dynamic> data) => Knowledge(
        data["id"],
        data["isUsed"],
      );
}

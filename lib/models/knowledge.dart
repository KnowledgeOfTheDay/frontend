import 'package:flutter/foundation.dart';

class Knowledge with ChangeNotifier {
  String? id;
  bool? isUsed;
  bool? hasWon;

  Knowledge(
    this.id,
    this.isUsed,
    this.hasWon,
  );

  Map toJson() => {
        "id": id,
        "isUsed": isUsed,
        "hasWon": hasWon,
      };

  static Knowledge fromJson(Map<String, dynamic> data) => Knowledge(
        data["id"],
        data["isUsed"],
        data["hasWon"],
      );
}

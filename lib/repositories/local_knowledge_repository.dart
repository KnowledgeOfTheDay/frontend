import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/knowledge.dart';

class LocalKnowledgeRepository {
  List<Knowledge> _items = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/knowledge.json');
  }

  Future<List<Knowledge>> readFromStorage() async {
    List<Knowledge> items = [];
    try {
      final file = await _localFile;

      final content = await file.readAsString();
      List<dynamic>? data = jsonDecode(content);
      if (null != data) {
        items = List<Knowledge>.from((data).map((item) => Knowledge.fromJson(item)));
      }
    } catch (e) {}

    return items;
  }

  Future<void> saveToStorage(List<Knowledge> items) async {
    final file = await _localFile;

    file.writeAsString(jsonEncode(items));
  }
}

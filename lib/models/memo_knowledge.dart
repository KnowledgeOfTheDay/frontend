import 'knowledge.dart';

class MemoKnowledge extends Knowledge {
  final String title;
  final String? description;

  MemoKnowledge(
    this.title,
    this.description,
    String? id,
    bool? isUsed,
  ) : super(id, isUsed);

  @override
  Map toJson() => {"title": title, "description": description, ...super.toJson()};

  static Knowledge fromJson(Map<String, dynamic> data) => MemoKnowledge(
        data["title"],
        data["description"],
        data["id"],
        data["isUsed"],
      );
}

import 'knowledge.dart';

class UrlKnowledge extends Knowledge {
  String url;

  UrlKnowledge(
    this.url,
    String? id,
    bool? isUsed,
  ) : super(id, isUsed);

  UrlKnowledge.local(this.url) : super(null, null);

  @override
  Map toJson() => {"url": url, ...super.toJson()};

  static Knowledge fromJson(Map<String, dynamic> data) => UrlKnowledge(
        data["url"],
        data["id"],
        data["isUsed"],
      );
}

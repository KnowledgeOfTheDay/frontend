class PostProcessor {
  static String processTitle(String originalTitle, {String? url}) {
    String result = originalTitle;
    if (null != url) {
      final uri = Uri.parse(url);

      if (uri.authority == "www.reddit.com") {
        result = result.replaceAll(RegExp(r"r\/[a-zA-Z\-_]* - "), "");
        result.trim();
      }
    }

    return result;
  }
}

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../models/url_knowledge.dart';

class UrlPreview extends StatelessWidget {
  final UrlKnowledge knowledge;
  const UrlPreview(this.knowledge, {Key? key}) : super(key: key);

  Map<String, String> _applyHeaders(String url) {
    Map<String, String> headers = {};
    final uri = Uri.parse(url);
    if (uri.authority.contains("reddit")) {
      headers.putIfAbsent("User-Agent", () => "");
    }

    return headers;
  }

  Widget _buildLoadingErrorWidget(BuildContext context, String link) {
    var height = ((MediaQuery.of(context).size.height) * 0.15);

    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(0),
        color: Theme.of(context).colorScheme.onInverseSurface,
      ),
      alignment: Alignment.center,
      child: Text(
        !AnyLinkPreview.isValidLink(link) ? 'Invalid Link' : 'Fetching data...',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnyLinkPreview(
      borderRadius: 0,
      bodyMaxLines: 3,
      cache: const Duration(days: 7),
      removeElevation: false,
      backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
      urlLaunchMode: LaunchMode.externalNonBrowserApplication,
      link: knowledge.url,
      showMultimedia: true,
      headers: _applyHeaders(knowledge.url),
      displayDirection: UIDirection.uiDirectionHorizontal,
      errorWidget: _buildLoadingErrorWidget(context, knowledge.url),
      placeholderWidget: _buildLoadingErrorWidget(context, knowledge.url),
    );
  }
}

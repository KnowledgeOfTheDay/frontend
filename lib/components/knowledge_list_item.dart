import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:kotd/models/knowledges.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class KnowledgeListItem extends StatelessWidget {
  final Knowledge knowledge;

  const KnowledgeListItem(this.knowledge, {Key? key}) : super(key: key);

  Future<void> _deleteItem(BuildContext context) async {
    try {
      await Provider.of<Knowledges>(context, listen: false).delete(knowledge.id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Deleting failed!",
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<void> _setKnowledgeToUsed(BuildContext context) async {
    try {
      await Provider.of<Knowledges>(context, listen: false).setIsUsed(knowledge.id);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Updating failed!",
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<void> _launchInWebView(String url) async {
    if (!await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication)) {
      throw "Could not launch $url";
    }
  }

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
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
              motion: const BehindMotion(),
              dismissible: DismissiblePane(
                onDismissed: () async => null != knowledge.isUsed ? await _setKnowledgeToUsed(context) : _deleteItem(context),
                closeOnCancel: true,
              ),
              children: [
                if (null != knowledge.isUsed)
                  SlidableAction(
                    onPressed: (_) async => await _setKnowledgeToUsed(context),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    label: "Used",
                    icon: Icons.check,
                  ),
                SlidableAction(
                  onPressed: (_) async => await _deleteItem(context),
                  backgroundColor: Theme.of(context).errorColor,
                  foregroundColor: Colors.white,
                  label: "Delete",
                  icon: Icons.delete,
                ),
              ],
            ),
            // endActionPane: ActionPane(
            //   motion: const ScrollMotion(),
            //   children: [
            //     SlidableAction(
            //       onPressed: (_) {},
            //       backgroundColor: Theme.of(context).colorScheme.primary,
            //       label: "Edit",
            //       icon: Icons.edit,
            //     )
            //   ],
            // ),
            child: AnyLinkPreview(
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
            )),
      ),
    );
  }
}

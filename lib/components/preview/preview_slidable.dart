import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kotd/components/preview/preview_error_item.dart';
import 'package:kotd/components/preview/preview_item.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:kotd/models/url_knowledge.dart';
import 'package:kotd/screens/knowledge_detail_screen.dart';
import 'package:provider/provider.dart';

import '../../enums/knowledge_action.dart';
import '../../enums/win_state.dart';
import '../../helpers/modal_helper.dart';
import '../../helpers/post_processor.dart';
import '../../models/knowledges.dart';
import '../../models/memo_knowledge.dart';

class PreviewSlidable extends StatefulWidget {
  final Knowledge item;

  const PreviewSlidable(this.item, {Key? key}) : super(key: key);

  @override
  State<PreviewSlidable> createState() => _PreviewSlidableState();
}

class _PreviewSlidableState extends State<PreviewSlidable> {
  String? title;
  String? description;
  String? image;
  String? url;
  bool hasError = false;
  bool isLoading = false;

  Map<String, String> _applyHeaders(String url) {
    Map<String, String> headers = {};
    final uri = Uri.parse(url);
    if (uri.authority.contains("reddit")) {
      headers.putIfAbsent("User-Agent", () => "");
    }

    return headers;
  }

  String _getWellFormedUri(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.isEmpty) {
        url = "http://$url";
      }
    } catch (error) {}
    return url;
  }

  void _openDetailScreen() {
    Navigator.of(context).pushNamed(KnowledgeDetailScreen.routeName, arguments: widget.item);
  }

  Future<void> _deleteItem(BuildContext context) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      await Provider.of<Knowledges>(context, listen: false).delete(widget.item.id!);
      if (!mounted) return;
      Navigator.of(context).popUntil(ModalRoute.withName("/"));
    } catch (error) {
      if (!mounted) return;
      scaffold.showSnackBar(const SnackBar(
          content: Text(
        "Deleting failed!",
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<bool> _setKnowledgeToUsed(BuildContext context) async {
    bool success = false;
    final state = await ModalHelper.showAskHasKnowledgeWonModal(context);
    if (!mounted) return false;
    switch (state) {
      case WinState.yes:
      case WinState.no:
        try {
          await Provider.of<Knowledges>(context, listen: false).setIsUsed(widget.item.id!, WinState.yes == state);
          success = true;
        } catch (error) {
          if (!mounted) return false;
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
            "Updating failed!",
            textAlign: TextAlign.center,
          )));
        }
        break;
      case WinState.cancel:
        success = false;
    }

    return success;
  }

  Future<void> _showAdditionalActionButtons(BuildContext ctx, {List<KnowledgeAction>? actions}) async {
    final action = await ModalHelper.showActionsModal(ctx, actions: actions);
    if (!mounted || null == action) return;
    switch (action) {
      case KnowledgeAction.markAsUsed:
        await _setKnowledgeToUsed(ctx);
        break;
      case KnowledgeAction.delete:
        await _deleteItem(ctx);
        break;
      case KnowledgeAction.edit:
      case KnowledgeAction.cancel:
        break;
    }
  }

  Future<void> _getData() async {
    setState(() => isLoading = true);
    switch (widget.item.runtimeType) {
      case UrlKnowledge:
        final item = widget.item as UrlKnowledge;
        final metadata =
            await AnyLinkPreview.getMetadata(link: _getWellFormedUri(item.url), headers: _applyHeaders(item.url), cache: const Duration(days: 14));
        if (null == metadata) {
          setState(() {
            hasError = true;
            url = item.url;
          });
        } else {
          setState(() {
            title = metadata.title;
            description = metadata.desc;
            image = metadata.image;
            url = metadata.url;
          });
        }
        break;
      case MemoKnowledge:
        final item = widget.item as MemoKnowledge;
        setState(() {
          title = item.title;
          description = item.description;
        });
        break;
    }
    setState(() => isLoading = false);
  }

  @override
  void didChangeDependencies() {
    _getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: PhysicalModel(
        elevation: 10,
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).shadowColor,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Slidable(
            key: UniqueKey(),
            endActionPane: !hasError
                ? ActionPane(
                    motion: const BehindMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () {},
                      confirmDismiss: () async => await _setKnowledgeToUsed(context) ?? false,
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (_) async => await _setKnowledgeToUsed(context),
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        label: "Used",
                        icon: Icons.check,
                      )
                    ],
                  )
                : null,
            child: SizedBox(
              width: double.infinity,
              height: (MediaQuery.of(context).size.height) * 0.15,
              child: Container(
                color: Theme.of(context).colorScheme.surfaceVariant,
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : hasError
                        ? PreviewErrorItem(
                            "Url is invalid or has no metadata to show, maybe try to correct it or delete the item.",
                            url ?? "",
                            onLongPress: () => _showAdditionalActionButtons(context,
                                actions: [KnowledgeAction.edit, KnowledgeAction.delete, KnowledgeAction.cancel]),
                          )
                        : PreviewItem(
                            PostProcessor.processTitle(title ?? "", url: url),
                            description ?? "",
                            imageUrl: image,
                            onTap: _openDetailScreen,
                            showMultiMedia: null != image,
                            onLongPress: () => _showAdditionalActionButtons(context),
                          ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

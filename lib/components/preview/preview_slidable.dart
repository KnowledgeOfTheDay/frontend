import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kotd/components/preview/preview_error_item.dart';
import 'package:kotd/components/preview/preview_item.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:kotd/models/url_knowledge.dart';
import 'package:kotd/screens/knowledge_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final uri = Uri.tryParse(url);
    if (null != uri && uri.host.isEmpty) {
      url = "http://$url";
    }
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
      scaffold.showSnackBar(SnackBar(
          content: Text(
        AppLocalizations.of(context)!.errorDeletingFailed,
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<bool> _shouldSetKnowledgeToUsed(BuildContext context) async {
    return await ModalHelper.showConfirmDialog(context, AppLocalizations.of(context)!.confirmationDialogTitle);
  }

  Future<void> _setKnowledgeToUsed(BuildContext context, bool hasWon) async {
    try {
      await Provider.of<Knowledges>(context, listen: false).setIsUsed(widget.item.id!, hasWon);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        AppLocalizations.of(context)!.errorUpdatingFailed,
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<void> _showAdditionalActionButtons(BuildContext ctx, {List<KnowledgeAction>? actions}) async {
    final action = await ModalHelper.showActionsModal(ctx, actions: actions);
    if (!mounted || null == action) return;
    switch (action) {
      case KnowledgeAction.markAsUsed:
        final result = await ModalHelper.showAskHasKnowledgeWonModal(context);
        if (!mounted || result == WinState.cancel) return;
        await _setKnowledgeToUsed(ctx, WinState.yes == result);
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
            startActionPane: !hasError
                ? ActionPane(
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(
                      onDismissed: () async => await _setKnowledgeToUsed(context, false),
                      confirmDismiss: () async => await _shouldSetKnowledgeToUsed(context),
                    ),
                    children: [
                      SlidableAction(
                        onPressed: (_) async {
                          final confirmation = await _shouldSetKnowledgeToUsed(context);
                          if (!mounted || !confirmation) return;
                          await _setKnowledgeToUsed(context, false);
                        },
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        label: AppLocalizations.of(context)!.knowledgeUsed,
                        icon: Icons.check,
                      ),
                      SlidableAction(
                        onPressed: (_) async {
                          final confirmation = await _shouldSetKnowledgeToUsed(context);
                          if (!mounted || !confirmation) return;
                          await _setKnowledgeToUsed(context, true);
                        },
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.white,
                        label: AppLocalizations.of(context)!.knowledgeWon,
                        icon: FontAwesomeIcons.crown,
                      ),
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
                            AppLocalizations.of(context)!.errorUrlInvalid,
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

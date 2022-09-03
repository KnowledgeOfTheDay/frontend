import 'dart:io';
import 'package:collection/collection.dart';

import 'package:flutter/material.dart';
import 'package:kotd/components/details/knowledge_detail_list.dart';
import 'package:kotd/helpers/modal_helper.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../enums/knowledge_action.dart';
import '../enums/win_state.dart';
import '../models/knowledges.dart';

class KnowledgeDetailScreen extends StatefulWidget {
  static const String routeName = "detail";

  const KnowledgeDetailScreen({Key? key}) : super(key: key);

  @override
  State<KnowledgeDetailScreen> createState() => _KnowledgeDetailScreenState();
}

class _KnowledgeDetailScreenState extends State<KnowledgeDetailScreen> {
  void _launchUrl(String url) async {
    var uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
    } else {
      try {
        await launchUrl(uri, mode: LaunchMode.externalNonBrowserApplication);
      } catch (err) {
        throw Exception('Could not launch $url. Error: $err');
      }
    }
  }

  void _openEditDialog(Knowledge item) async {
    await ModalHelper.showEditModal(context, id: item.id, initialValues: item.toJson(), isEdit: true);
    setState(() {});
  }

  Future<void> _deleteItem(Knowledge item) async {
    final scaffold = ScaffoldMessenger.of(context);
    try {
      await Provider.of<Knowledges>(context, listen: false).delete(item.id!);
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

  Future<void> _setKnowledgeToUsed(Knowledge item) async {
    final state = await ModalHelper.showAskHasKnowledgeWonModal(context);
    if (!mounted) return;
    switch (state) {
      case WinState.yes:
      case WinState.no:
        try {
          await Provider.of<Knowledges>(context, listen: false).setIsUsed(item.id!, WinState.yes == state);
          setState(() {});
        } catch (error) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            AppLocalizations.of(context)!.errorUpdatingFailed,
            textAlign: TextAlign.center,
          )));
        }
        break;
      case WinState.cancel:
        break;
    }
  }

  Future<void> _showAdditionalActionButtons(Knowledge item) async {
    final action = await ModalHelper.showActionsModal(context, actions: item.isUsed ? [KnowledgeAction.delete, KnowledgeAction.cancel] : null);
    if (!mounted || null == action) return;
    switch (action) {
      case KnowledgeAction.markAsUsed:
        await _setKnowledgeToUsed(item);
        break;
      case KnowledgeAction.delete:
        await _deleteItem(item);
        break;
      case KnowledgeAction.edit:
        _openEditDialog(item);
        break;
      case KnowledgeAction.cancel:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final item = Provider.of<Knowledges>(context, listen: false).items.firstWhereOrNull((element) => element.id == id);

    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        actions: [
          if (!(item?.isUsed ?? false))
            IconButton(
                icon: const Icon(Icons.check),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () async => _setKnowledgeToUsed(item!)),
          if (null != item?.url)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: () async => _launchUrl(item!.url!),
            ),
          if (null != item)
            IconButton(
                icon: Icon(Platform.isAndroid ? Icons.more_vert : Icons.more_horiz),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () => _showAdditionalActionButtons(item)),
        ],
      ),
      body: null == item ? const Center(child: CircularProgressIndicator()) : KnowledgeDetailList(item),
    );
  }
}

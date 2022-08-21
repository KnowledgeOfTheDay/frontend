import 'dart:io';

import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:kotd/components/details/knowledge_detail_list.dart';
import 'package:kotd/helpers/modal_helper.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:kotd/models/memo_knowledge.dart';
import 'package:kotd/models/url_knowledge.dart';
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
  late Knowledge item;

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

  Future<void> _deleteItem() async {
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

  Future<void> _setKnowledgeToUsed() async {
    final state = await ModalHelper.showAskHasKnowledgeWonModal(context);
    if (!mounted) return;
    switch (state) {
      case WinState.yes:
      case WinState.no:
        try {
          await Provider.of<Knowledges>(context, listen: false).setIsUsed(item.id!, WinState.yes == state);
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

  Future<Widget> _getDetails(Knowledge item) async {
    switch (item.runtimeType) {
      case UrlKnowledge:
        final metadata = await AnyLinkPreview.getMetadata(link: (item as UrlKnowledge).url);
        return KnowledgeDetailList(
          title: metadata?.title,
          description: metadata?.desc,
          image: metadata?.image,
          url: metadata?.url,
        );
      case MemoKnowledge:
        final memo = item as MemoKnowledge;
        return KnowledgeDetailList(
          title: memo.title,
          description: memo.description,
        );
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  Future<void> _showAdditionalActionButtons() async {
    final action = await ModalHelper.showActionsModal(context);
    if (!mounted || null == action) return;
    switch (action) {
      case KnowledgeAction.markAsUsed:
        await _setKnowledgeToUsed();
        break;
      case KnowledgeAction.delete:
        await _deleteItem();
        break;
      case KnowledgeAction.edit:
      case KnowledgeAction.cancel:
        break;
    }
  }

  @override
  void didChangeDependencies() {
    item = ModalRoute.of(context)!.settings.arguments as Knowledge;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        actions: [
          if (!(item.isUsed ?? false))
            IconButton(
                icon: const Icon(Icons.check),
                highlightColor: Colors.transparent,
                splashColor: Colors.transparent,
                onPressed: () async => _setKnowledgeToUsed()),
          if (item is UrlKnowledge)
            IconButton(
              icon: const Icon(Icons.open_in_new),
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              focusColor: Colors.transparent,
              onPressed: () async => _launchUrl((item as UrlKnowledge).url),
            ),
          IconButton(
              icon: Icon(Platform.isAndroid ? Icons.more_vert : Icons.more_horiz),
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: _showAdditionalActionButtons),
        ],
      ),
      body: FutureBuilder(
        future: _getDetails(item),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data as Widget;
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}

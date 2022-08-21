import 'package:flutter/material.dart';
import 'package:kotd/enums/knowledge_action.dart';
import 'package:kotd/enums/win_state.dart';
import 'knowledge_type.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../components/edit/modal_with_scroll.dart';

class ModalHelper {
  static void showEditModal(BuildContext context, KnowledgeType type, {Map<String, dynamic> initialValues = const {}}) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (ctx) => ModalWithScroll(
        type,
        initialValues: initialValues,
      ),
    );
  }

  static Future<WinState> showAskHasKnowledgeWonModal(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Did this knowledge win?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, WinState.cancel),
              child: const Text("cancel"),
            ),
            TextButton(
              child: const Text("no"),
              onPressed: () {
                Navigator.pop(context, WinState.no);
              },
            ),
            TextButton(
              child: const Text("yes"),
              onPressed: () {
                Navigator.pop(context, WinState.yes);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<KnowledgeAction?> showActionsModal(BuildContext context, {List<KnowledgeAction>? actions}) async {
    List<Widget> _getActions(List<KnowledgeAction>? actions) {
      return (actions ?? KnowledgeAction.values)
          .map(
            (element) => KnowledgeAction.cancel == element
                ? TextButton(onPressed: () => Navigator.of(context).pop(KnowledgeAction.cancel), child: Text(element.getTitle()))
                : ListTile(leading: element.getIcon(), title: Text(element.getTitle()), onTap: () => Navigator.of(context).pop(element)),
          )
          .toList();
    }

    return await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: const Text("What do you want to do?"),
            actionsPadding: EdgeInsets.zero,
            actions: [
              ..._getActions(actions),
            ],
          );
        });
  }
}

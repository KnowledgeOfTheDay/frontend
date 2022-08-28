import 'package:flutter/material.dart';
import 'package:kotd/enums/knowledge_action.dart';
import 'package:kotd/enums/win_state.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../components/edit/modal_with_scroll.dart';

class ModalHelper {
  static Future<void> showEditModal(BuildContext context, {String? id, Map<String, dynamic> initialValues = const {}, bool isEdit = false}) async {
    await showCupertinoModalBottomSheet(
      context: context,
      expand: true,
      builder: (ctx) => ModalWithScroll(
        id: id,
        initialValues: initialValues,
        isEdit: isEdit,
      ),
    );
  }

  static Future<bool> showConfirmDialog(BuildContext context, String title) async {
    return await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(title),
            actions: [
              TextButton(
                child: Text(AppLocalizations.of(context)!.dialogNo),
                onPressed: () {
                  Navigator.pop(context, false);
                },
              ),
              TextButton(
                child: Text(AppLocalizations.of(context)!.dialogYes),
                onPressed: () {
                  Navigator.pop(context, true);
                },
              ),
            ],
          );
        });
  }

  static Future<WinState> showAskHasKnowledgeWonModal(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.knowledgeWonDialogTitle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, WinState.cancel),
              child: Text(AppLocalizations.of(context)!.dialogCancel),
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.dialogNo),
              onPressed: () {
                Navigator.pop(context, WinState.no);
              },
            ),
            TextButton(
              child: Text(AppLocalizations.of(context)!.dialogYes),
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
                ? TextButton(onPressed: () => Navigator.of(context).pop(KnowledgeAction.cancel), child: Text(element.getTitle(context)))
                : ListTile(leading: element.getIcon(), title: Text(element.getTitle(context)), onTap: () => Navigator.of(context).pop(element)),
          )
          .toList();
    }

    return await showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            title: Text(AppLocalizations.of(context)!.actionDialogTitle),
            actionsPadding: EdgeInsets.zero,
            actions: [
              ..._getActions(actions),
            ],
          );
        });
  }
}

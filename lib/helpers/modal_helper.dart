import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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

  static Future<bool?> showAskHasKnowledgeWonModal(BuildContext context, Future<void> Function(BuildContext, bool) action) async {
    return await showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Did this knowledge win?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("cancel"),
            ),
            TextButton(
              child: const Text("no"),
              onPressed: () {
                action(ctx, false);
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text("yes"),
              onPressed: () {
                action(ctx, true);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }
}

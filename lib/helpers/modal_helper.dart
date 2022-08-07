import 'package:flutter/cupertino.dart';
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
}

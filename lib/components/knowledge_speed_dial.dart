import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import '../helpers/knowledge_type.dart';

import '../helpers/modal_helper.dart';

class KnowledgeSpeedDial extends StatelessWidget {
  const KnowledgeSpeedDial({Key? key}) : super(key: key);

  SpeedDialChild getUrlActionButton(BuildContext context) {
    return SpeedDialChild(
      child: const Icon(Icons.link),
      label: "Website",
      onTap: () => ModalHelper.showEditModal(context, KnowledgeType.url),
    );
  }

  SpeedDialChild getMemoActionButton(BuildContext context) {
    return SpeedDialChild(
      child: const Icon(Icons.note),
      label: "Note",
      onTap: () => ModalHelper.showEditModal(context, KnowledgeType.memo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      icon: Icons.add,
      activeIcon: Icons.close,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      spaceBetweenChildren: 4,
      buttonSize: const Size(56, 56),
      children: [
        getUrlActionButton(context),
        getMemoActionButton(context),
      ],
    );
  }
}

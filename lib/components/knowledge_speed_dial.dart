import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../helpers/modal_helper.dart';

class KnowledgeSpeedDial extends StatelessWidget {
  const KnowledgeSpeedDial({Key? key}) : super(key: key);

  SpeedDialChild getUrlActionButton(BuildContext context) {
    return SpeedDialChild(
      child: const Icon(Icons.link),
      label: AppLocalizations.of(context)!.knowledgeUrl,
      onTap: () => ModalHelper.showEditModal(context),
    );
  }

  SpeedDialChild getMemoActionButton(BuildContext context) {
    return SpeedDialChild(
      child: const Icon(Icons.note),
      label: AppLocalizations.of(context)!.knowledgeNote,
      onTap: () => ModalHelper.showEditModal(context),
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

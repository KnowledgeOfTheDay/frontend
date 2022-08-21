import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum KnowledgeAction {
  edit,
  markAsUsed,
  delete,
  cancel,
}

extension KnowledgeActionExtension on KnowledgeAction {
  Icon getIcon() {
    switch (this) {
      case KnowledgeAction.edit:
        return const Icon(Icons.edit);
      case KnowledgeAction.markAsUsed:
        return const Icon(Icons.check);
      case KnowledgeAction.delete:
        return const Icon(Icons.delete);
      case KnowledgeAction.cancel:
        return const Icon(Icons.cancel);
    }
  }

  String getTitle(BuildContext context) {
    switch (this) {
      case KnowledgeAction.edit:
        return AppLocalizations.of(context)!.knowledgeEdit;
      case KnowledgeAction.markAsUsed:
        return AppLocalizations.of(context)!.knowledgeMarkAsUsed;
      case KnowledgeAction.delete:
        return AppLocalizations.of(context)!.knowledgeDelete;
      case KnowledgeAction.cancel:
        return AppLocalizations.of(context)!.dialogCancel;
    }
  }
}

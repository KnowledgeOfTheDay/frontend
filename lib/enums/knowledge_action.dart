import 'package:flutter/material.dart';

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

  String getTitle() {
    switch (this) {
      case KnowledgeAction.edit:
        return "Edit";
      case KnowledgeAction.markAsUsed:
        return "Mark as used";
      case KnowledgeAction.delete:
        return "Delete";
      case KnowledgeAction.cancel:
        return "Cancel";
    }
  }
}

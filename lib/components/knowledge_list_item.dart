import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'preview/memo_preview.dart';
import 'preview/url_preview.dart';
import '../models/knowledge.dart';
import '../models/knowledges.dart';
import '../models/memo_knowledge.dart';
import '../models/url_knowledge.dart';
import 'package:provider/provider.dart';

class KnowledgeListItem extends StatelessWidget {
  final Knowledge knowledge;

  const KnowledgeListItem(this.knowledge, {Key? key}) : super(key: key);

  Future<void> _deleteItem(BuildContext context) async {
    try {
      await Provider.of<Knowledges>(context, listen: false).delete(knowledge.id!);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Deleting failed!",
        textAlign: TextAlign.center,
      )));
    }
  }

  Future<void> _setKnowledgeToUsed(BuildContext context) async {
    try {
      await Provider.of<Knowledges>(context, listen: false).setIsUsed(knowledge.id!);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
        "Updating failed!",
        textAlign: TextAlign.center,
      )));
    }
  }

  Widget generatePreview(Knowledge knowledge) {
    switch (knowledge.runtimeType) {
      case UrlKnowledge:
        return UrlPreview(knowledge as UrlKnowledge);
      case MemoKnowledge:
        return MemoPreview(knowledge as MemoKnowledge);
      default:
        return const Center();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.0),
        child: Slidable(
            key: UniqueKey(),
            startActionPane: ActionPane(
              motion: const BehindMotion(),
              dismissible: DismissiblePane(
                onDismissed: () async => null != knowledge.isUsed ? await _setKnowledgeToUsed(context) : _deleteItem(context),
                closeOnCancel: true,
              ),
              children: [
                if (null != knowledge.isUsed)
                  SlidableAction(
                    onPressed: (_) async => await _setKnowledgeToUsed(context),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Colors.white,
                    label: "Used",
                    icon: Icons.check,
                  ),
                SlidableAction(
                  onPressed: (_) async => await _deleteItem(context),
                  backgroundColor: Theme.of(context).errorColor,
                  foregroundColor: Colors.white,
                  label: "Delete",
                  icon: Icons.delete,
                ),
              ],
            ),
            // endActionPane: ActionPane(
            //   motion: const ScrollMotion(),
            //   children: [
            //     SlidableAction(
            //       onPressed: (_) {},
            //       backgroundColor: Theme.of(context).colorScheme.primary,
            //       label: "Edit",
            //       icon: Icons.edit,
            //     )
            //   ],
            // ),
            child: generatePreview(knowledge)),
      ),
    );
  }
}

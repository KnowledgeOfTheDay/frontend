import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kotd/components/priority.dart';
import 'package:kotd/components/resizable_image.dart';
import 'package:kotd/models/knowledge.dart';
import 'package:kotd/screens/filtered_list_screen.dart';

import '../../helpers/post_processor.dart';

class KnowledgeDetailList extends StatelessWidget {
  final Knowledge item;

  const KnowledgeDetailList(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (null != item.imageUrl) ResizableImage(item.imageUrl!),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Stack(children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  PostProcessor.processTitle(item.title ?? "", url: item.url),
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: !item.isUsed
                    ? Priority(value: item.priority)
                    : item.hasWon == true
                        ? const Padding(
                            padding: EdgeInsets.all(3),
                            child: Icon(
                              FontAwesomeIcons.crown,
                              color: Colors.amber,
                              size: 20,
                            ),
                          )
                        : Container(),
              )
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(item.description ?? ""),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
            child: Wrap(
              spacing: 5,
              children: [
                for (final category in item.categories)
                  RawChip(
                    label: Text(category.name),
                    onPressed: () => Navigator.of(context).pushNamed(FilteredListScreen.routeName, arguments: category),
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

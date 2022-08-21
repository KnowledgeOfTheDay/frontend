import 'package:flutter/material.dart';
import 'package:kotd/components/resizable_image.dart';

import '../../helpers/post_processor.dart';

class KnowledgeDetailList extends StatelessWidget {
  final String? title;
  final String? description;
  final String? image;
  final String? url;

  const KnowledgeDetailList({this.title, this.description, this.image, this.url, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (null != image) ResizableImage(image!),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              textAlign: TextAlign.center,
              PostProcessor.processTitle(title ?? "", url: url),
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Text(description ?? ""),
          )
        ],
      ),
    );
  }
}

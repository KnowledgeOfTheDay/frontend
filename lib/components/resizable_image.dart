import 'package:flutter/material.dart';

class ResizableImage extends StatefulWidget {
  final bool isFullsize;
  final int minHeight;
  final String imageUrl;

  const ResizableImage(this.imageUrl, {this.isFullsize = false, this.minHeight = 120, Key? key}) : super(key: key);

  @override
  State<ResizableImage> createState() => _ResizableImageState();
}

class _ResizableImageState extends State<ResizableImage> {
  late bool isExpanded;

  @override
  void initState() {
    isExpanded = widget.isFullsize;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.bottomRight, children: [
      ClipRect(
        child: Align(
          alignment: Alignment.topCenter,
          heightFactor: isExpanded ? 1.0 : .6,
          widthFactor: 1.0,
          child: Image.network(
            widget.imageUrl,
            alignment: Alignment.center,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: Ink(
            decoration: ShapeDecoration(
                color: Theme.of(context).backgroundColor.withOpacity(.5), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: IconButton(
              highlightColor: Colors.transparent,
              hoverColor: Colors.transparent,
              splashColor: Colors.transparent,
              enableFeedback: false,
              onPressed: () => setState(() {
                isExpanded = !isExpanded;
              }),
              icon: isExpanded ? const Icon(Icons.close_fullscreen) : const Icon(Icons.open_in_full),
            ),
          ),
        ),
      ),
    ]);
  }
}

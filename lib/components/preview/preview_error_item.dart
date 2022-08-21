import 'package:flutter/material.dart';

class PreviewErrorItem extends StatelessWidget {
  final String title;
  final String description;
  final Color? bgColor;
  final Function() onLongPress;

  const PreviewErrorItem(this.title, this.description, {required this.onLongPress, this.bgColor, Key? key}) : super(key: key);

  double computeTitleFontSize(double width) {
    var size = width * 0.13;
    if (size > 15) {
      size = 15;
    }
    return size;
  }

  int computeTitleLines(layoutHeight) {
    return layoutHeight >= 100 ? 2 : 1;
  }

  int computeBodyLines(layoutHeight) {
    var lines = 1;
    if (layoutHeight > 40) {
      lines += (layoutHeight - 40.0) ~/ 15.0 as int;
    }
    return lines;
  }

  Widget _buildTitleContainer(TextStyle titleTS_, int? maxLines_) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 3, 1),
      child: Column(
        children: <Widget>[
          Container(
            alignment: const Alignment(-1.0, -1.0),
            child: Text(
              title,
              style: titleTS_,
              overflow: TextOverflow.ellipsis,
              maxLines: maxLines_,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBodyContainer(TextStyle bodyTS_, int? maxLines_) {
    return Expanded(
      flex: 2,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(5, 3, 5, 0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                alignment: const Alignment(-1.0, -1.0),
                child: Text(
                  description,
                  textAlign: TextAlign.left,
                  style: bodyTS_,
                  overflow: TextOverflow.ellipsis,
                  maxLines: maxLines_,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        final layoutWidth = constraints.biggest.width;
        final layoutHeight = constraints.biggest.height;

        final titleFontSize_ = TextStyle(
          fontSize: computeTitleFontSize(layoutWidth),
          color: Colors.black,
          fontWeight: FontWeight.bold,
        );
        final bodyFontSize_ = TextStyle(
          fontSize: computeTitleFontSize(layoutWidth) - 1,
          color: Colors.grey,
          fontWeight: FontWeight.w400,
        );

        return Material(
          child: InkWell(
            onLongPress: onLongPress,
            customBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Row(children: [
              Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: LayoutBuilder(builder: (context, constraint) {
                      return Icon(Icons.error, color: Theme.of(context).errorColor, size: constraint.biggest.height);
                    }),
                  )),
              Expanded(
                flex: 4,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildTitleContainer(titleFontSize_, computeTitleLines(layoutHeight)),
                      _buildBodyContainer(bodyFontSize_, computeBodyLines(layoutHeight))
                    ],
                  ),
                ),
              )
            ]),
          ),
        );
      },
    );
  }
}

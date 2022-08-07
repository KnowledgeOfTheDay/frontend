import 'package:flutter/material.dart';
import '../../models/memo_knowledge.dart';

class MemoPreview extends StatelessWidget {
  final MemoKnowledge knowledge;
  const MemoPreview(this.knowledge, {Key? key}) : super(key: key);

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
    return lines - 2;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
      ),
      height: (MediaQuery.of(context).size.height) * 0.15,
      child: LayoutBuilder(
        builder: (context, constraints) {
          var layoutWidth = constraints.biggest.width;
          var layoutHeight = constraints.biggest.height;

          var titleFontSize_ = TextStyle(
            fontSize: computeTitleFontSize(layoutWidth),
            color: Colors.black,
            fontWeight: FontWeight.bold,
          );
          var bodyFontSize_ = TextStyle(
            fontSize: computeTitleFontSize(layoutWidth) - 1,
            color: Colors.grey,
            fontWeight: FontWeight.w400,
          );

          return InkWell(
            child: Row(
              children: <Widget>[
                const SizedBox(width: 5),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildTitleContainer(titleFontSize_, computeTitleLines(layoutHeight)),
                        _buildBodyContainer(bodyFontSize_, computeBodyLines(layoutHeight))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTitleContainer(TextStyle titleTS_, int? maxLines_) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 2, 3, 1),
      child: Column(
        children: <Widget>[
          Container(
            alignment: const Alignment(-1.0, -1.0),
            child: Text(
              knowledge.title,
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
                  knowledge.description ?? "",
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
}

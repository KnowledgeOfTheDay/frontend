import 'package:flutter/material.dart';

class Priority extends StatelessWidget {
  final int value;

  const Priority({this.value = 1, super.key});

  Color? _computePriorityColor() {
    return Colors.amber.withOpacity(value * .2);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: 1 < value
          ? Align(
              alignment: Alignment.topRight,
              child: Icon(
                Icons.star,
                size: 20,
                color: _computePriorityColor(),
              ),
            )
          : const SizedBox(width: 20),
    );
  }
}

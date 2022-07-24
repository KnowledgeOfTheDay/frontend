import 'package:flutter/material.dart';

class AuthButton extends StatelessWidget {
  final String title;
  final Function action;

  const AuthButton(this.title, this.action, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => action(),
      child: ListTile(
        title: Text(
          title,
          textAlign: TextAlign.center,
        ),
        tileColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

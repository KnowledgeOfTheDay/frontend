import 'package:flutter/material.dart';

class HallOfFameScreen extends StatefulWidget {
  static const String routeName = "hall-of-fame";

  const HallOfFameScreen({Key? key}) : super(key: key);

  @override
  State<HallOfFameScreen> createState() => _HallOfFameScreenState();
}

class _HallOfFameScreenState extends State<HallOfFameScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(),
    );
  }
}

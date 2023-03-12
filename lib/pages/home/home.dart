import 'package:flutester/pages//home/status.dart';
import 'package:flutester/service/inverter.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage(this._inverter, {super.key});

  final Inverter _inverter;

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(child: Status(_inverter, const Duration(seconds: 1))),
      );
}

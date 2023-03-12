import 'dart:math';

import 'package:flutester/app_state.dart';
import 'package:flutester/pages/home/home.dart';
import 'package:flutester/service/inverter_simulator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (context) => AppState(),
        child: MaterialApp(
          title: 'fluttest',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
          ),
          home: HomePage(InverterSimulator(Random())),
        ),
      );
}

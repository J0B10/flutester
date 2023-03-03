

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'home.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'fluttest',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: HomePage(),
      ),
    );
  }
}


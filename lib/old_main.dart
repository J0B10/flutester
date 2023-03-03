import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'fluttest',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var favorites = <WordPair>{};

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  bool isFavorite() => favorites.contains(current);

  void toggleFavorite() {
    if (isFavorite()) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selected = 0;

  Widget _getPage() {
    switch (selected) {
      case 0:
        return GeneratorPage();
      case 1:
        return FavoritesPage();
      default:
        throw UnimplementedError('no page $selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            if (constraints.maxWidth >= 720)
              SafeArea(
                child: NavigationRail(
                  extended: constraints.maxWidth >= 600,
                  destinations: [
                    NavigationRailDestination(
                      icon: Icon(Icons.home),
                      label: Text('Home'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.favorite),
                      label: Text('Favorites'),
                    ),
                  ],
                  selectedIndex: selected,
                  onDestinationSelected: (val) {
                    setState(() => selected = val);
                  },
                ),
              ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: _getPage(),
              ),
            )
          ],
        ),
        bottomNavigationBar: constraints.maxWidth >= 720
            ? null
            : BottomNavigationBar(
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Favorites',
                  ),
                ],
                currentIndex: selected,
                onTap: (val) {
                  setState(() => selected = val);
                },
              ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    final pair = appState.current;
    final icon = appState.isFavorite() ? Icons.favorite : Icons.favorite_border;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('A random AWESOME idea:'),
          SizedBox(height: 20),
          BigCard(pair: pair),
          SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () => appState.toggleFavorite(),
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 20),
              ElevatedButton(
                onPressed: () => appState.getNext(),
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();

    return ListView(
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text('You have ${appState.favorites.length} favourites:'),
        ),
        for (final fav in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(fav.asLowerCase),
          )
      ],
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          pair.asLowerCase,
          style: style,
          semanticsLabel: pair.asPascalCase,
        ),
      ),
    );
  }
}

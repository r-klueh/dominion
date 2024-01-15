import 'dart:convert';

import 'package:dominion/data/game_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<GameCard> _cards = [];

  List<GameCard> _basicCards = [];

  void _incrementCounter() {
    List<GameCard> _selection = [..._basicCards];
    _selection.shuffle();

    setState(() {
      _cards = _selection.take(10).toList();
    });
  }

  void _loadCards() {
    DefaultAssetBundle.of(context)
        .loadString("data/basic.json")
        .then((value) => jsonDecode(value) as List<dynamic>)
        .then(
            (value) => value.map((e) => GameCard(e['name'], "basic")).toList())
        .then((value) => setState(() {
              _basicCards = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    _loadCards();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ..._cards.map((e) => Text(
                  e.name,
                  style: Theme.of(context).textTheme.headlineMedium,
                ))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

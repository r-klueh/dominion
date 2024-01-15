import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:dominion/data/game_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<GameCard>> _cards = {};

  List<GameCard> _basicCards = [];
  List<GameCard> _intrigeCards = [];

  void _selectCards() {
    List<GameCard> selection = [..._basicCards, ..._intrigeCards];
    selection.shuffle();

    setState(() {
      _cards = Map.fromEntries(selection
          .take(10)
          .fold<Map<String, List<GameCard>>>({}, (previousValue, element) {
            Map<String, List<GameCard>> packages = previousValue;
            String package = element.package;
            if (!packages.containsKey(package)) {
              packages[package] = [];
            }
            packages[package]?.add(element);
            return packages;
          })
          .entries
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key)));
    });
  }

  void _loadCards() {
    DefaultAssetBundle.of(context)
        .loadString("data/basic.json")
        .then((value) => jsonDecode(value) as List<dynamic>)
        .then(
            (value) => value.map((e) => GameCard(e['name'], "Basis")).toList())
        .then((value) => setState(() {
              _basicCards = value;
            }));

    DefaultAssetBundle.of(context)
        .loadString("data/intrige.json")
        .then((value) => jsonDecode(value) as List<dynamic>)
        .then((value) =>
            value.map((e) => GameCard(e['name'], "Intrige")).toList())
        .then((value) => setState(() {
              _intrigeCards = value;
            }));
  }

  @override
  Widget build(BuildContext context) {
    _loadCards();

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ..._cards.entries.toList().slices(3).map(
                  (e) => Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ...e.map(
                        (e) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key,
                              style: Theme.of(context).textTheme.headlineMedium,
                            ),
                            ...e.value.map((card) => Text(card.name))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectCards,
        tooltip: 'SelectCards',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

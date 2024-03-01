import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'game_card.dart';

class SettingsData extends ChangeNotifier {
  List<GameCard> _basicCards = [];
  List<GameCard> _intrigeCards = [];

  final List<bool> _selectedPackages = [true, true];

  SettingsData(BuildContext context) {
    readCards(context, "Basic").then((value) => {_basicCards = value});

    readCards(context, "Intrige").then((value) => {_intrigeCards = value});
  }

  List<GameCard> get availableCards => [_basicCards, _intrigeCards]
      .whereIndexed((index, element) => _selectedPackages[index])
      .flattened
      .toList();

  List<bool> get selectedPackages => _selectedPackages;

  void toggleGamePack(int index) {
    _selectedPackages[index] = !_selectedPackages[index];
    notifyListeners();
  }
}

Future<List<GameCard>> readCards(BuildContext context, String package) =>
    DefaultAssetBundle.of(context)
        .loadString("data/${package.toLowerCase()}.json")
        .then((value) => jsonDecode(value) as List<dynamic>)
        .then((value) => value
            .map((e) =>
                GameCard(e['name'], package, e['cost'], parseTypes(e['types'])))
            .toList());

List<CardType> parseTypes(dynamic types) =>
    (types! as List<dynamic>).map((e) => CardType.fromString(e)).toList();

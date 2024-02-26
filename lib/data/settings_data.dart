import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'game_card.dart';

class SettingsData extends ChangeNotifier {
  List<GameCard> _basicCards = [];
  List<GameCard> _intrigeCards = [];

  final List<bool> _selectedPackages = [true, true];

  SettingsData(BuildContext context) {
    DefaultAssetBundle.of(context)
        .loadString("data/basic.json")
        .then((value) => jsonDecode(value) as List<dynamic>)
        .then(
            (value) => value.map((e) => GameCard(e['name'], "Basis")).toList())
        .then((value) => {_basicCards = value});

    DefaultAssetBundle.of(context)
        .loadString("data/intrige.json")
        .then((value) => jsonDecode(value) as List<dynamic>)
        .then((value) =>
            value.map((e) => GameCard(e['name'], "Intrige")).toList())
        .then((value) => {_intrigeCards = value});
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

import 'package:collection/collection.dart';
import 'package:dominion/data/game_card.dart';
import 'package:dominion/data/settings_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'settings_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, List<GameCard>> _cards = {};

  void _selectCards(BuildContext context) {
    List<GameCard> selection =
        Provider.of<SettingsData>(context, listen: false).availableCards;
    selection.forEach((element) {print(element.package);});

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
            packages[package]!.add(element);
            packages[package]!.sort((a, b) => compareCards(a, b));
            return packages;
          })
          .entries
          .toList()
        ..sort((a, b) => a.key.compareTo(b.key)));
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Row(
            children: [
              FilledButton(
                  onPressed: () => {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const SettingsPage();
                        }))
                      },
                  child: const Text("Settings"))
            ],
          ),
          Consumer<SettingsData>(builder: (context, value, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ToggleButtons(
                    constraints: const BoxConstraints(
                      minHeight: 40.0,
                      minWidth: 90.0,
                    ),
                    isSelected: value.selectedPackages,
                    fillColor: theme.colorScheme.primary,
                    selectedColor: theme.colorScheme.onPrimary,
                    color: theme.colorScheme.onPrimary.withOpacity(0.5),
                    onPressed: (index) {
                      Provider.of<SettingsData>(context, listen: false)
                          .toggleGamePack(index);
                    },
                    children: [
                      Text("Basis", style: theme.textTheme.bodyLarge),
                      Text("Intrige", style: theme.textTheme.bodyLarge),
                      Text("Abenteuer", style: theme.textTheme.bodyLarge)
                    ])
              ],
            );
          }),
          Expanded(
            child: Center(
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
                                    style: theme.textTheme.headlineMedium,
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
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _selectCards(context),
        tooltip: 'SelectCards',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

int compareCards(GameCard a, GameCard b) {
  int costCompare = a.cost - b.cost;
  if (costCompare != 0) {
    return costCompare;
  }

  return a.name.compareTo(b.name);
}

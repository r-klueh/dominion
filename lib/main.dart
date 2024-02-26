import 'package:dominion/data/settings_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const DominionApp());
}

class DominionApp extends StatelessWidget {
  const DominionApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dominion',
      theme: ThemeData(
        colorScheme: const ColorScheme.dark(primary: Color(0xFF081287), onPrimary: Colors.white),
      ),
      home: ChangeNotifierProvider(
        create: (context) => SettingsData(context),
        child: const HomePage()
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

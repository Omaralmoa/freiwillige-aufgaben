// lib/main.dart

import 'package:flutter/material.dart';
import 'start.dart'; // Annahme: 'start.dart' ist dein Haupt-Widget

void main() {
  runApp( MyApp(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meine App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Start(),
    );
  }
}

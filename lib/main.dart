// lib/main.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cart/shopping_cart.dart';
import 'produkt_provider.dart';
import 'start.dart';
import 'package:appwrite/appwrite.dart';
import 'constant.dart';

void main() {
  Client client = Client()
    ..setEndpoint(AppwriteConstants.endpoint)
    ..setProject(AppwriteConstants.projectId);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ShoppingCart()),
        ChangeNotifierProvider(create: (_) => ProductsProvider(client)),
      ],
      child: MyApp(),
    ),
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

// lib/start.dart
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'regist.dart';
import 'Anmelden.dart';
import 'constant.dart';

class Start extends StatefulWidget {
  const Start({super.key});

  @override
  _StartState createState() => _StartState();
}

class _StartState extends State<Start> {
  late Client client;
  late Databases databases;

  @override
  void initState() {
    super.initState();
    // Initialisiere den Appwrite-Client
    client = Client()
        .setEndpoint(AppwriteConstants.endpoint) // Setze deine Appwrite-Endpoint-URL
        .setProject(AppwriteConstants.projectId); // Setze deine Projekt-ID

    // Initialisiere die Datenbank-Instanz
    databases = Databases(client);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Willkommen'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Willkommen bei unserer App',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AnmeldenScreen(),
                    ),
                  );
                },
                child: const Text('Anmelden'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50), // Button auf volle Breite
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registrieren(databases: databases),
                    ),
                  );
                },
                child: const Text('Registrieren'),
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

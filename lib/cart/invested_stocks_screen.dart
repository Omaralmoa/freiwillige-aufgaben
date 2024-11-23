import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:gymapp/constant.dart';

class InvestedStocksScreen extends StatefulWidget {
  @override
  _InvestedStocksScreenState createState() => _InvestedStocksScreenState();
}

class _InvestedStocksScreenState extends State<InvestedStocksScreen> {
  late Databases _databases;
  List<Map<String, dynamic>> investedStocks = [];

  @override
  void initState() {
    super.initState();
    Client client = Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId);

    _databases = Databases(client);
    fetchInvestments();
  }

  Future<void> fetchInvestments() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.investaktiencollection,
      );

      setState(() {
        investedStocks = response.documents.map((doc) => {
          ...doc.data,
          'id': doc.$id // Speichern der Dokument-ID für spätere Löschung
        }).toList();
      });
    } catch (e) {
      print('Fehler beim Abrufen der Investitionen: $e');
    }
  }

  Future<void> sellStock(String documentId) async {
    try {
      await _databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.investaktiencollection,
        documentId: documentId,
      );

      // Erfolgsnachricht anzeigen und Liste aktualisieren
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aktie erfolgreich verkauft!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );

      // Aktuelle Liste der Investitionen abrufen
      fetchInvestments();
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Verkauf der Aktie: ${e.message}'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: investedStocks.length,
        itemBuilder: (context, index) {
          final stock = investedStocks[index];
          return ListTile(
            title: Text(stock['aktie']),
            subtitle: Text('Investiert: ${stock['investiert']} €'),
            trailing: IconButton(
              icon: Icon(Icons.sell, color: Colors.red),
              onPressed: () {
                sellStock(stock['id']); // Verkaufen-Funktion aufrufen
              },
            ),
          );
        },
      ),
    );
  }
}

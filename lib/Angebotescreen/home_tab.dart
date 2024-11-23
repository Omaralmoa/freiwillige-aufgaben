import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import '../constant.dart';
import 'angebote.dart';
import 'angebote_detail.dart'; // Importiere die Detailseite

class HomeTab extends StatefulWidget {
  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  late Databases _databases;
  List<Angebot> _angebote = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    // Initialisiere den Appwrite-Client und die Datenbank
    Client client = Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId);

    _databases = Databases(client);
    fetchAngebote();
  }

  Future<void> fetchAngebote() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.angebotecollection,
      );

      List<Angebot> fetchedAngebote = response.documents.map((doc) {
        return Angebot.fromMap(doc.data, doc.$id);
      }).toList();

      setState(() {
        _angebote = fetchedAngebote;
        _isLoading = false;
      });
    } on AppwriteException catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Abrufen der Angebote: ${e.message}';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Ein unerwarteter Fehler ist aufgetreten: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage.isNotEmpty) {
      return Center(child: Text(_errorMessage, style: const TextStyle(color: Colors.red)));
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GridView.builder(
        itemCount: _angebote.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Anzahl der Spalten
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.75, // Verhältnis Breite/Höhe
        ),
        itemBuilder: (context, index) {
          final angebot = _angebote[index];
          return GestureDetector(
            onTap: () {
              // Navigiere zur Detailseite
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AngebotDetail(angebot: angebot),
                ),
              );
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Bild des Angebots
                  Expanded(
                    child: ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                      child: _buildImage(angebot.bild),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      angebot.name,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Verkaufspreis: €${angebot.verkaufspreis}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('Mietpreis: €${angebot.mietpreis}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: Text(
                      angebot.vermietet ? 'Vermietet' : 'Verfügbar',
                      style: TextStyle(
                        color: angebot.vermietet ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildImage(String bild) {
    try {
      final decodedBytes = base64Decode(bild);
      return Image.memory(
        decodedBytes,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    } catch (e) {
      // Fehler beim Dekodieren
      return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
    }
  }
}

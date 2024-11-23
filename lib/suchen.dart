// lib/Angebotescreen/search_tab.dart

import 'dart:convert'; // Für Base64-Dekodierung
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'produkt_provider.dart';
import 'Angebotescreen/angebote_detail.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductsProvider>(
      builder: (context, productsProvider, child) {
        if (productsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (productsProvider.errorMessage.isNotEmpty) {
          return Center(
              child: Text(
            productsProvider.errorMessage,
            style: const TextStyle(color: Colors.red),
          ));
        }

        final searchResults = productsProvider.searchProdukte(_searchQuery);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Suche nach Produkten',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: searchResults.isEmpty
                  ? const Center(child: Text('Keine Produkte gefunden.'))
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GridView.builder(
                        itemCount: searchResults.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Anzahl der Spalten
                          mainAxisSpacing: 8.0,
                          crossAxisSpacing: 8.0,
                          childAspectRatio: 0.75, // Verhältnis Breite/Höhe
                        ),
                        itemBuilder: (context, index) {
                          final angebot = searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              // Navigiere zur Detailseite
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AngebotDetail(angebot: angebot),
                                ),
                              );
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Bild des Angebots
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(8.0)),
                                      child: _buildImage(angebot.bild),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      angebot.name,
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                        'Verkaufspreis: €${angebot.verkaufspreis}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Text(
                                        'Mietpreis: €${angebot.mietpreis}'),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 4.0),
                                    child: Text(
                                      angebot.vermietet
                                          ? 'Vermietet'
                                          : 'Verfügbar',
                                      style: TextStyle(
                                        color: angebot.vermietet
                                            ? Colors.red
                                            : Colors.green,
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
                    ),
            ),
          ],
        );
      },
    );
  }

  /// Hilfsmethode zur Bildanzeige
  Widget _buildImage(String bild) {
    if (bild.startsWith('http') || bild.startsWith('https')) {
      // Bild ist eine URL
      return Image.network(
        bild,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator());
        },
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.broken_image, size: 50, color: Colors.grey),
      );
    } else {
      // Versuch, das Bild als Base64-codierten String zu dekodieren
      try {
        final decodedBytes = base64Decode(bild);
        return Image.memory(
          decodedBytes,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.broken_image, size: 50, color: Colors.grey),
        );
      } catch (e) {
        // Fehler beim Dekodieren, zeige ein Platzhalter-Icon
        return const Icon(Icons.broken_image, size: 50, color: Colors.grey);
      }
    }
  }
}



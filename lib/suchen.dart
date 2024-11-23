import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'constant.dart';

class SearchTab extends StatefulWidget {
  const SearchTab({super.key});

  @override
  State<SearchTab> createState() => _SearchTabState();
}

class _SearchTabState extends State<SearchTab> {
  late Databases _databases;
  List<Map<String, dynamic>> allStocks = [];
  List<Map<String, dynamic>> filteredStocks = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Client client = Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId);

    _databases = Databases(client);
    fetchStocks();
  }

  Future<void> fetchStocks() async {
    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.aktiencollection,
      );

      setState(() {
        allStocks = response.documents.map((doc) => doc.data).toList();
        filteredStocks = allStocks; // Starten mit allen verfügbaren Aktien
      });
    } catch (e) {
      print('Fehler beim Abrufen der Aktien: $e');
    }
  }

  void filterStocks(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredStocks = allStocks;
      } else {
        filteredStocks = allStocks
            .where((stock) =>
                stock['name'] != null &&
                stock['name'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Suche nach Aktien',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
              onChanged: filterStocks,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: filteredStocks.isEmpty
                  ? const Center(child: Text('Keine Aktien gefunden'))
                  : ListView.builder(
                      itemCount: filteredStocks.length,
                      itemBuilder: (context, index) {
                        final stock = filteredStocks[index];
                        return ListTile(
                          title: Text(stock['name'] ?? 'Unbekannte Aktie'),
                          subtitle: Text(
                              'Nennwert: ${stock['nennwert']}, Marktwert: ${stock['marktwert']}'),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

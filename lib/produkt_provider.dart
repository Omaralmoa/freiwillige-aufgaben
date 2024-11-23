// lib/models/products_provider.dart

import 'package:flutter/foundation.dart';
import 'Angebotescreen/angebote.dart';
import 'package:appwrite/appwrite.dart';
import 'constant.dart';

class ProductsProvider extends ChangeNotifier {
  final Databases _databases;

  List<Angebot> _produkte = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Angebot> get produkte => _produkte;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  ProductsProvider(Client client) : _databases = Databases(client) {
    fetchProdukte();
  }

  Future<void> fetchProdukte() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.angebotecollection,
      );

      _produkte = response.documents
          .map((doc) => Angebot.fromMap(doc.data, doc.$id))
          .toList();
      _isLoading = false;
      notifyListeners();
    } on AppwriteException catch (e) {
      _errorMessage = 'Fehler beim Abrufen der Produkte: ${e.message}';
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Ein unerwarteter Fehler ist aufgetreten: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
    }
  }

  List<Angebot> searchProdukte(String query) {
    if (query.isEmpty) {
      return _produkte;
    }

    return _produkte
        .where((produkt) =>
            produkt.name.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<void> createAngebot({
    required String name,
    required String verkaufspreis,
    required String mietpreis,
    required String bild, // Base64-String
  }) async {
    try {
      final document = await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.angebotecollection,
        documentId: 'unique()', // Automatisch generierte ID
        data: {
          'name': name,
          'verkaufspreis': verkaufspreis,
          'mietpreis': mietpreis,
          'bild': bild, // Speicherung des Base64-Strings
          'vermietet': false, // Standardmäßig nicht vermietet
        },
      );

      // Füge das neue Angebot zur lokalen Liste hinzu
      _produkte.add(Angebot.fromMap(document.data, document.$id));
      notifyListeners();
    } on AppwriteException catch (e) {
      throw Exception('Fehler beim Erstellen des Angebots: ${e.message}');
    } catch (e) {
      throw Exception('Ein unerwarteter Fehler ist aufgetreten: ${e.toString()}');
    }
  }
}

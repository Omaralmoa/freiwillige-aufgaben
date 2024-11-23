import 'home.dart';
import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'constant.dart'; // Importiere die 

class AnmeldenScreen extends StatefulWidget {
  @override
  _AnmeldenScreenState createState() => _AnmeldenScreenState();
}

class _AnmeldenScreenState extends State<AnmeldenScreen> {
  late Client _client;
  late Databases _databases;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _client = Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId);
    
    _databases = Databases(_client); // Initialisiere die Datenbank
  }

  Future<void> _login() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      // Suche den Benutzer in der Datenbank
      final response = await _databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        queries: [
          Query.equal('email', email), // Vergleiche die E-Mail
          Query.equal('password', password) // Vergleiche das Passwort
        ],
      );

      if (response.documents.isEmpty) {
        throw Exception('Falsche E-Mail oder falsches Passwort.');
      }

      // Benutzer gefunden, hole die ID des Benutzers
      final userId = response.documents.first.$id;

      // Navigiere zur Homepage mit der E-Mail und Benutzer-ID
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => Homepage(
            email: email,
            userId: userId,
          )
        ),
      );
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Anmelden: ${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Anmelden')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'E-Mail',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Passwort',
                errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
              ),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _login,
              child: const Text('Anmelden'),
            ),
            if (_errorMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  _errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

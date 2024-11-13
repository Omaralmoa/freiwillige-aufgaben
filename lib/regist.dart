// lib/registrieren.dart

import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'constant.dart'; // Stelle sicher, dass der Dateiname korrekt ist

class Registrieren extends StatefulWidget {
  final Databases databases;

  const Registrieren({Key? key, required this.databases}) : super(key: key);

  @override
  _RegistrierenState createState() => _RegistrierenState();
}

class _RegistrierenState extends State<Registrieren> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Definiere den Form-Key

  // Controller für die Textfelder
  final TextEditingController _vornameController = TextEditingController();
  final TextEditingController _nachnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwortController = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void dispose() {
    // Controller entsorgen, wenn das Widget entfernt wird
    _vornameController.dispose();
    _nachnameController.dispose();
    _emailController.dispose();
    _passwortController.dispose();
    super.dispose();
  }

  Future<void> _registrieren() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = '';
      });

      String vorname = _vornameController.text.trim();
      String nachname = _nachnameController.text.trim();
      String email = _emailController.text.trim();
      String password = _passwortController.text.trim();

      try {
        // Speichern des Passworts im Klartext ohne Hashing
        await widget.databases.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.userCollectionId,
          documentId: 'unique()', // Automatisch generierte ID
          data: {
            'vorname': vorname,
            'nachname': nachname,
            'email': email,
            'password': password, // Klartext-Passwort speichern
          },
        );

        // Registrierung erfolgreich
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registrierung erfolgreich!')),
        );
        Navigator.pop(context); // Zurück zur Anmeldeseite oder Startseite
      } on AppwriteException catch (e) {
        // Fehler behandeln
        setState(() {
          _errorMessage = 'Registrierung fehlgeschlagen: ${e.message}';
        });
      } catch (e) {
        // Allgemeiner Fehler
        setState(() {
          _errorMessage = 'Ein Fehler ist aufgetreten: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrieren'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Form(
                key: _formKey, // Verwende den definierten Form-Key
                child: ListView(
                  children: [
                    // Vorname
                    TextFormField(
                      controller: _vornameController,
                      decoration: const InputDecoration(
                        labelText: 'Vorname',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie Ihren Vornamen ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Nachname
                    TextFormField(
                      controller: _nachnameController,
                      decoration: const InputDecoration(
                        labelText: 'Nachname',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie Ihren Nachnamen ein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // E-Mail
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-Mail',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),

                    // Passwort
                    TextFormField(
                      controller: _passwortController,
                      decoration: InputDecoration(
                        labelText: 'Passwort',
                        errorText: _errorMessage.isNotEmpty ? _errorMessage : null,
                      ),
                      obscureText: true, // Passwort verstecken
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Bitte geben Sie ein Passwort ein';
                        }
                        if (value.length < 6) {
                          return 'Das Passwort muss mindestens 6 Zeichen lang sein';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Registrieren Button
                    ElevatedButton(
                      onPressed: _registrieren,
                      child: const Text('Registrieren'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                      ),
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
      ),
    );
  }
}

// lib/Angebotescreen/create_angebot_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'produkt_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'dart:convert'; // Für Base64-Kodierung

class CreateAngebotScreen extends StatefulWidget {
  const CreateAngebotScreen({Key? key}) : super(key: key);

  @override
  _CreateAngebotScreenState createState() => _CreateAngebotScreenState();
}

class _CreateAngebotScreenState extends State<CreateAngebotScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _verkaufspreisController = TextEditingController();
  final TextEditingController _mietpreisController = TextEditingController();

  Uint8List? _selectedImageBytes; // Verwende Uint8List für Bilddaten
  bool _isSubmitting = false;
  String _errorMessage = '';
  bool _isSuccess = false;

  Future<void> _pickImage() async {
    try {
      // Öffne den File Picker
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true, // Lade die Datei-Daten direkt herunter (für Web)
      );

      if (result != null && result.files.single.bytes != null) {
        setState(() {
          _selectedImageBytes = result.files.single.bytes;
        });
      } else if (result != null && result.files.single.path != null) {
        // Für mobile Plattformen
        File file = File(result.files.single.path!);
        _selectedImageBytes = file.readAsBytesSync();
        setState(() {});
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Auswählen des Bildes: ${e.toString()}';
      });
    }
  }

  Future<String?> _convertImageToBase64() async {
    if (_selectedImageBytes == null) return null;
    try {
      String base64Image = base64Encode(_selectedImageBytes!);
      return base64Image;
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Konvertieren des Bildes: ${e.toString()}';
      });
      return null;
    }
  }

  Future<void> _createAngebot() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedImageBytes == null) {
      setState(() {
        _errorMessage = 'Bitte wähle ein Bild aus.';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = '';
    });

    final String name = _nameController.text.trim();
    final String verkaufspreis = _verkaufspreisController.text.trim();
    final String mietpreis = _mietpreisController.text.trim();

    try {
      // Konvertiere das Bild in Base64
      String? base64Image = await _convertImageToBase64();
      if (base64Image == null) {
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      // Jetzt das Angebot erstellen
      final productsProvider = Provider.of<ProductsProvider>(context, listen: false);
      await productsProvider.createAngebot(
        name: name,
        verkaufspreis: verkaufspreis,
        mietpreis: mietpreis,
        bild: base64Image, // Speichere den Base64-String
      );

      setState(() {
        _isSuccess = true;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Fehler beim Erstellen des Angebots: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bild des Angebots',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: _selectedImageBytes != null
                ? Image.memory(
                    _selectedImageBytes!,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.add_a_photo,
                    color: Colors.grey,
                    size: 50,
                  ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildSuccessMessage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
            size: 100,
          ),
          const SizedBox(height: 20),
          const Text(
            'Erfolgreich erstellt',
            style: TextStyle(
              fontSize: 24,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Zurück zum vorherigen Screen
            },
            child: const Text('Zurück'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmittingIndicator() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: ListView(
        children: [
          // Name des Angebots
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Name des Angebots',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte den Namen des Angebots eingeben';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Verkaufspreis
          TextFormField(
            controller: _verkaufspreisController,
            decoration: const InputDecoration(
              labelText: 'Verkaufspreis (€)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte den Verkaufspreis eingeben';
              }
              if (double.tryParse(value) == null) {
                return 'Bitte eine gültige Zahl eingeben';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Mietpreis
          TextFormField(
            controller: _mietpreisController,
            decoration: const InputDecoration(
              labelText: 'Mietpreis (€)',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Bitte den Mietpreis eingeben';
              }
              if (double.tryParse(value) == null) {
                return 'Bitte eine gültige Zahl eingeben';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),

          // Bild Auswahl
          _buildImageSection(),
          const SizedBox(height: 24),

          // Fehlernachricht
          if (_errorMessage.isNotEmpty)
            Text(
              _errorMessage,
              style: const TextStyle(color: Colors.red),
            ),

          // Erstellen Button
          ElevatedButton(
            onPressed: _createAngebot,
            child: const Text('Angebot erstellen'),
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neues Angebot erstellen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isSubmitting
            ? _buildSubmittingIndicator()
            : _isSuccess
                ? _buildSuccessMessage()
                : _buildForm(),
      ),
    );
  }
}

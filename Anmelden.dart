import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hausaufgabe/main.dart';

class Anmelden extends StatefulWidget {
  final Client client;
  const Anmelden({Key? key, required this.client}) : super(key: key);

  @override
  _AnmeldenState createState() => _AnmeldenState();
}

class _AnmeldenState extends State<Anmelden> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _handleSignIn() async {
    final email = _emailController.text;
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
      const  SnackBar(content: Text('Bitte füllen Sie alle Felder aus.')) 
      );
      return;
    }

    try {
      final account = Account(widget.client);
      await account.createSession(
        userId: "66e6dcef00308d809941",  // Überprüfe, ob userId und secret korrekt sind
        secret: "187Oma1243",
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Hauswervawltung(client: widget.client)), 
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler bei der Anmeldung: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Anmelden"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Text("E-Mail-Adresse"),
            SizedBox(height: 5),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          const  SizedBox(height: 20),
          const  Text("Passwort"),
          const  SizedBox(height: 5),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _handleSignIn,
              child: Text("Anmelden"),
            ),
          ],
        ),
      ),
    );
  }
}

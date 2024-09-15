import 'package:flutter/material.dart';
import 'package:hausaufgabe/Anmelden.dart';
import 'Imos.dart';
import 'package:hausaufgabe/Mieter.dart';
import 'package:appwrite/appwrite.dart';
import 'package:hausaufgabe/zahlung.dart';

Client client = Client()
  ..setEndpoint('https://cloud.appwrite.io/v1')
  ..setProject('66e6d6fb000371ec2562')
  ..setSelfSigned(status: true);

void main() {
  runApp(haha());
}

class haha extends StatelessWidget {
  const haha({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Anmelden(client: client),
    );
  }
}

class Hauswervawltung extends StatefulWidget {
  final Client client;
  const Hauswervawltung({Key? key, required this.client}) : super(key: key);

  @override
  State<Hauswervawltung> createState() => _HauswervawltungState();
}

class _HauswervawltungState extends State<Hauswervawltung> {
  int _currentindex = 0;
  List<Widget> _page = [imos(), mieter(), zahlung()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hausverwaltung")),
      body: IndexedStack(
        index: _currentindex,
        children: _page,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Immobilien"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "Mieter"),
          BottomNavigationBarItem(icon: Icon(Icons.money), label: "Zahlung"),
        ],
        currentIndex: _currentindex,
        onTap: (index) {
          setState(() {
            _currentindex = index;
          });
        },
      ),
    );
  }
}

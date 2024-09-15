import 'package:flutter/material.dart';

class imos extends StatefulWidget {
  const imos({Key? key}) : super(key: key);

  @override
  State<imos> createState() => _imosState();
}

class _imosState extends State<imos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildImmoTile(
                  title: "Sonnenhof Apartments",
                  address: "Sonnenstraße 12, 80331 München",
                  number: "3"),
              Divider(),
              _buildImmoTile(
                  title: "Gartenblick Residenz",
                  address: "Blumenweg 5, 10115 Berlin",
                  number: "3"),
              Divider(),
              _buildImmoTile(
                  title: "Waldstraße 22",
                  address: "Waldstraße 22, 44137 Dortmund",
                  number: "3"),
              Divider(),
              _buildImmoTile(
                  title: "Hafenblick Lofts",
                  address: "Höhenweg 18, 70597 Stuttgart",
                  number: "3"),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methode zum Erstellen der Immobilien-Tile
  Widget _buildImmoTile(
      {required String title,
      required String address,
      required String number}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        backgroundColor: Colors.teal,
        child: Icon(Icons.home, color: Colors.white),
      ),
      title: Text(
        title,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      subtitle: Text(address),
      trailing: CircleAvatar(
        backgroundColor: Colors.grey[200],
        child: Text(
          number,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Center(child: Text("Infos zu $title")),
                content: Text(address),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text("Schließen")),
                ],
              );
            });
      },
    );
  }
}

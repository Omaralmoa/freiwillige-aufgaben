import 'package:flutter/material.dart';

class mieter extends StatefulWidget {
  const mieter({Key? key}) : super(key: key);

  @override
  State<mieter> createState() => _mieterState();
}

class _mieterState extends State<mieter> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              _buildMieterTile(
                  name: "Anna Bauer",
                  address: "Sonnenhof Apartments",
                  number: "1",
                  phone: "+49 176 12345678",
                  email: "anna.bauer@mail.de"),
              Divider(),
              _buildMieterTile(
                  name: "Michael Schmidt",
                  address: "Gartenblick Residenz",
                  number: "2",
                  phone: "+49 176 98765432",
                  email: "michael.schmidt@mail.de"),
              Divider(),
              _buildMieterTile(
                  name: "Lisa Müller",
                  address: "Waldstraße 22",
                  number: "3",
                  phone: "+49 176 54321678",
                  email: "lisa.mueller@mail.de"),
              Divider(),
              _buildMieterTile(
                  name: "Jonas Weber Scholz",
                  address: "Adlerhöhe Estates",
                  number: "4",
                  phone: "+49 176 65437821",
                  email: "jonas.scholz@mail.de"),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methode zum Erstellen der Mieter-Tile
  Widget _buildMieterTile(
      {required String name,
      required String address,
      required String number,
      required String phone,
      required String email}) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      leading: CircleAvatar(
        child: Image.network(
            "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRF1IwK6-SxM83UpFVY6WtUZxXx-phss_gAUfdKbkTfau6VWVkt"),
      ),
      title: Text(
        name,
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
                title: Center(child: Text("Infos zu $name")),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.phone, color: Colors.teal),
                        SizedBox(width: 10),
                        Text(phone),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.email, color: Colors.teal),
                        SizedBox(width: 10),
                        Text(email),
                      ],
                    ),
                  ],
                ),
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

import 'package:flutter/material.dart';

class zahlung extends StatefulWidget {
  const zahlung({Key? key}) : super(key: key);

  @override
  State<zahlung> createState() => _zahlungState();
}

class _zahlungState extends State<zahlung> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            _zahlung(
                context: context,
                name: "Anna Bauer",
                imobilie: "Sonnenhof Apartments",
                datepay: "11.01.2025",
                summe: "250 Euro",
                payed: true),
            Divider(),
            _zahlung(
                context: context,
                name: "Michael Schmidt",
                imobilie: "Gartenblick Residenz",
                datepay: "06.11.2024",
                summe: "1000",
                payed: true),
            Divider(),
            _zahlung(
                context: context,
                name: "Lisa Müller",
                imobilie: " Waldstraße 22",
                datepay: "15.09.2024",
                summe: "500",
                payed: false),
            Divider(),
            _zahlung(
                context: context,
                name: "Jonas Weber Scholz",
                imobilie: "Adlerhöhe Estates",
                datepay: "19.03.2026",
                summe: "2000",
                payed: false)
          ],
        ),
      )),
    );
  }
}

Widget _zahlung({
  required BuildContext context,
  required String name,
  required String imobilie,
  required String datepay,
  required String summe,
  required bool payed,
}) {
  return ListTile(
    contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    leading: CircleAvatar(
      backgroundColor: Colors.teal,
      child: Icon(
        Icons.home,
        color: Colors.white,
      ),
    ),
    title: Text(
      name,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
    ),
    subtitle: Text(
      imobilie,
    ),
    trailing: Text(
      datepay,
    ),
    onTap: () {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Zahlung von $name"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [Text("Betrag: $summe")],
                  ),
                  Row(
                    children: [
                      Text("Dataum der zahlung: $datepay"),
                    ],
                  ),
                  Row(
                    children: [Text("Bezahlt $payed")],
                  ),
                ],
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Schließen"))
              ],
            );
          });
    },
  );
}

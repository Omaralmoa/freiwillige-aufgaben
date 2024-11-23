import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import 'constant.dart';

class SettingsScreen extends StatefulWidget {
  final Document currentUserDocument;
  SettingsScreen({super.key, required this.currentUserDocument});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Client client = Client();

  bool light = true;
  bool light2 = true;

  @override
  void initState() {
    super.initState();
    client
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId);
  }

  void logout() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => MyApp()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Null-Überprüfung für Datenfelder "Name" und "Email"
    final userData = widget.currentUserDocument.data;
    final userName = userData?["Name"] ?? "Name nicht verfügbar";
    final userEmail = userData?["Email"] ?? "Email nicht verfügbar";

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 58.0),
                child: Icon(Icons.account_circle, size: 98),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 7.0, bottom: 3.0),
                child: Text(
                  userName,
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 22.0),
                child: Text(
                  userEmail,
                  style: TextStyle(
                    color: Color.fromARGB(255, 140, 138, 138),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 42.0),
                child: Container(
                  width: 120,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      backgroundColor: Colors.black,
                    ),
                    child: Text(
                      "Edit Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 258.0),
                  child: Text(
                    "Inventories",
                    style: TextStyle(
                      color: Color.fromARGB(255, 140, 138, 138),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 380,
                height: 136,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.store),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 3.0),
                          child: Text(
                            "Meine Mitarbeiter",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 147, 146, 146),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: Container(
                          width: 337,
                          height: 1,
                          color: Color.fromARGB(255, 203, 198, 209),
                        ),
                      ),
                      ListTile(
                        onTap: () {},
                        leading: Icon(Icons.support),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            "Support",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 147, 146, 146),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, top: 12.0),
                child: Padding(
                  padding: const EdgeInsets.only(right: 254.0),
                  child: Text(
                    "Preferences",
                    style: TextStyle(
                      color: Color.fromARGB(255, 140, 138, 138),
                      fontWeight: FontWeight.w800,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              Container(
                width: 380,
                height: 280,
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28)),
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.notification_add),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 2.0),
                          child: Text(
                            "Push notifications",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        trailing: Switch(
                          value: light,
                          onChanged: (bool value) {
                            setState(() {
                              light = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: Container(
                          width: 337,
                          height: 1,
                          color: Color.fromARGB(255, 203, 198, 209),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.face),
                        title: Padding(
                          padding: const EdgeInsets.only(left: 6.0),
                          child: Text(
                            "Face ID",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        trailing: Switch(
                          value: light2,
                          onChanged: (bool value) {
                            setState(() {
                              light2 = value;
                            });
                          },
                          activeColor: Colors.green,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: Container(
                          width: 337,
                          height: 1,
                          color: Color.fromARGB(255, 203, 198, 209),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.more),
                        title: Text(
                          "PIN Code",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward,
                          color: Color.fromARGB(255, 147, 146, 146),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(7.5),
                        child: Container(
                          width: 337,
                          height: 1,
                          color: Color.fromARGB(255, 203, 198, 209),
                        ),
                      ),
                      ListTile(
                        onTap: logout,
                        leading: Icon(Icons.door_back_door),
                        title: Text(
                          "Logout",
                          style: TextStyle(
                            color: Color.fromARGB(255, 167, 23, 23),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

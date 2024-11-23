import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'Angebotescreen/home_tab.dart';
import 'cart/invested_stocks_screen.dart';
import 'suchen.dart';
import 'settingscreen.dart';
import 'constant.dart';

class Homepage extends StatefulWidget {
  final String email;
  final String userId;

  const Homepage({Key? key, required this.email, required this.userId}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _currentIndex = 0;
  late List<Widget> _children;
  final Client _client = Client();
  late Databases _databases;
  Document? _currentUserDocument;

  @override
  void initState() {
    super.initState();
    _client
        .setEndpoint(AppwriteConstants.endpoint)
        .setProject(AppwriteConstants.projectId);
    _databases = Databases(_client);

    // Lade das Benutzerdokument basierend auf der `userId`
    _fetchUserDocument();
  }

  Future<void> _fetchUserDocument() async {
    try {
      // Abrufen des Benutzerdokuments mit `userId`
      Document response = await _databases.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.userCollectionId,
        documentId: widget.userId,
      );

      setState(() {
        _currentUserDocument = response;
      });

      // Aktualisiere die Tabs, sobald das Dokument geladen ist
      _children = [
        HomeTab(),
        SearchTab(),
        InvestedStocksScreen(),
        SettingsScreen(currentUserDocument: _currentUserDocument!), // Übergeben des Dokuments
      ];
    } catch (e) {
      print("Fehler beim Abrufen des Benutzerdokuments: $e");
    }
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meine App'),
        centerTitle: true,
      ),
      body: _currentUserDocument == null
          ? Center(child: CircularProgressIndicator()) // Zeige einen Ladeindikator an, bis das Dokument geladen ist
          : _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Suche',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: 'Ausgewählte Aktien',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Einstellungen',
          ),
        ],
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

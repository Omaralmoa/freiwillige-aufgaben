import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'aktie.dart';
import 'package:appwrite/appwrite.dart';
import 'package:gymapp/constant.dart';

class AktieDetailScreen extends StatefulWidget {
  final Aktie aktie;

  const AktieDetailScreen({Key? key, required this.aktie}) : super(key: key);

  @override
  _AktieDetailScreenState createState() => _AktieDetailScreenState();
}

class _AktieDetailScreenState extends State<AktieDetailScreen> {
  String selectedRange = "1W";
  late Databases _databases;
  String userId = "rrr"; // Benutzer-ID
  TextEditingController investController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Client client = Client()
      ..setEndpoint(AppwriteConstants.endpoint)
      ..setProject(AppwriteConstants.projectId);

    _databases = Databases(client);
  }

  Future<void> addInvestment(String aktieName, String investiert) async {
    try {
      bool amInvestieren = double.parse(investiert) > 0;

      await _databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.investaktiencollection,
        documentId: 'unique()', // Generiert eine eindeutige ID
        data: {
          'user': userId,
          'aktie': aktieName,
          'aminvestieren': amInvestieren,
          'investiert': investiert,
        },
      );

      // Erfolgsnachricht anzeigen
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Investition in ${widget.aktie.name} erfolgreich!'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.green,
        ),
      );
    } on AppwriteException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Kauf: ${e.message}'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  List<FlSpot> getChartData() {
    switch (selectedRange) {
      case "1T":
        return [FlSpot(0, 10), FlSpot(1, 12), FlSpot(2, 11), FlSpot(3, 13)];
      case "1W":
        return [FlSpot(0, 10), FlSpot(1, 12), FlSpot(2, 10), FlSpot(3, 15), FlSpot(4, 13)];
      case "1M":
        return [FlSpot(0, 10), FlSpot(5, 15), FlSpot(10, 12), FlSpot(15, 17), FlSpot(20, 13)];
      case "1J":
        return [FlSpot(0, 10), FlSpot(2, 20), FlSpot(4, 15), FlSpot(6, 30), FlSpot(8, 25)];
      case "Max":
        return [FlSpot(0, 5), FlSpot(10, 15), FlSpot(20, 25), FlSpot(30, 20), FlSpot(40, 30)];
      default:
        return [FlSpot(0, 10), FlSpot(1, 12), FlSpot(2, 10), FlSpot(3, 15), FlSpot(4, 13)];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Portfolio',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '${double.parse(widget.aktie.marktwert).toStringAsFixed(2)} €',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      buildTimeRangeButton("1T"),
                      buildTimeRangeButton("1W"),
                      buildTimeRangeButton("1M"),
                      buildTimeRangeButton("1J"),
                      buildTimeRangeButton("Max"),
                    ],
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: investController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Investitionsbetrag (€)",
                      border: OutlineInputBorder(),
                      hintText: 'Geben Sie den Betrag ein',
                    ),
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                    ),
                    onPressed: () {
                      final investAmount = investController.text;
                      if (double.tryParse(investAmount) != null && double.parse(investAmount) > 0) {
                        addInvestment(widget.aktie.name, investAmount);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bitte geben Sie einen gültigen Betrag ein!'),
                            duration: Duration(seconds: 2),
                            backgroundColor: Colors.orange,
                          ),
                        );
                      }
                    },
                    child: Text("Aktie kaufen"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: SizedBox(
                height: 300,
                child: LineChart(
                  LineChartData(
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}€',
                              style: TextStyle(fontSize: 12, color: Colors.black),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            switch (value.toInt()) {
                              case 0:
                                return Text('1T', style: TextStyle(fontSize: 12));
                              case 1:
                                return Text('1W', style: TextStyle(fontSize: 12));
                              case 2:
                                return Text('1M', style: TextStyle(fontSize: 12));
                              case 3:
                                return Text('1J', style: TextStyle(fontSize: 12));
                              case 4:
                                return Text('Max', style: TextStyle(fontSize: 12));
                              default:
                                return Text('');
                            }
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(show: true, border: Border.all(color: Colors.black26)),
                    lineBarsData: [
                      LineChartBarData(
                        spots: getChartData(),
                        isCurved: true,
                        color: Colors.black,
                        barWidth: 2,
                        belowBarData: BarAreaData(show: false),
                        dotData: FlDotData(show: false),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hilfsfunktion zum Erstellen von Zeitraumauswahl-Buttons
  Widget buildTimeRangeButton(String range) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRange = range;
        });
      },
      child: Text(
        range,
        style: TextStyle(
          color: selectedRange == range ? Colors.black : Colors.grey,
          fontWeight: selectedRange == range ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }
}

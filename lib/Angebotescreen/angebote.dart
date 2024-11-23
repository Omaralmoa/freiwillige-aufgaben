// lib/Angebotescreen/angebot.dart

class Angebot {
  final String id;
  final String name;
  final String verkaufspreis; // Geändert von double zu String
  final String bild;
  final bool vermietet;
  final String mietpreis; // Geändert von double zu String

  Angebot({
    required this.id,
    required this.name,
    required this.verkaufspreis,
    required this.bild,
    required this.vermietet,
    required this.mietpreis,
  });

  factory Angebot.fromMap(Map<String, dynamic> map, String id) {
    return Angebot(
      id: id,
      name: map['name'] ?? '',
      verkaufspreis: map['verkaufspreis']?.toString() ?? '0.00', // Konvertiere zu String
      bild: map['bild'] ?? '',
      vermietet: map['vermietet'] ?? false,
      mietpreis: map['mietpreis']?.toString() ?? '0.00', // Konvertiere zu String
    );
  }
}

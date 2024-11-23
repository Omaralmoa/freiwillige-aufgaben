class Aktie {
  final String id;
  final String name;
  final String nennwert;
  final String marktwert;
  final String imageUrl;

  Aktie({
    required this.id,
    required this.name,
    required this.nennwert,
    required this.marktwert,
    required this.imageUrl,
  });

  factory Aktie.fromMap(Map<String, dynamic> data, String id) {
    return Aktie(
      id: id,
      name: data['name'],
      nennwert: data['nennwert'],
      marktwert: data['marktwert'],
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150', // Standardbild
    );
  }
}

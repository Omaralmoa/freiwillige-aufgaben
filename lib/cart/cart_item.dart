// lib/models/cart_item.dart

import 'package:eiscreme/Angebotescreen/angebote.dart';

class CartItem {
  final Angebot angebot;
  final String action; // "Mieten" oder "Kaufen"

  CartItem({required this.angebot, required this.action});
}

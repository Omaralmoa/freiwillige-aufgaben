// lib/models/shopping_cart.dart

import 'package:flutter/foundation.dart';
import 'cart_item.dart';
import 'package:eiscreme/Angebotescreen/angebote.dart';

class ShoppingCart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  void addItem(Angebot angebot, String action) {
    _items.add(CartItem(angebot: angebot, action: action));
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

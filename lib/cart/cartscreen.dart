// lib/Angebotescreen/cart_tab.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'shopping_cart.dart';

class CartTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ShoppingCart>(
      builder: (context, shoppingCart, child) {
        final items = shoppingCart.items;

        if (items.isEmpty) {
          return const Center(
            child: Text('Ihr Einkaufswagen ist leer.'),
          );
        }

        return ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            final cartItem = items[index];
            return ListTile(
              leading: Image.network(
                cartItem.angebot.bild,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(Icons.broken_image),
              ),
              title: Text(cartItem.angebot.name),
              subtitle: Text(cartItem.action == 'Kaufen'
                  ? 'Kaufpreis: €${cartItem.angebot.verkaufspreis}'
                  : 'Mietpreis: €${cartItem.angebot.mietpreis}'),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle, color: Colors.red),
                onPressed: () {
                  shoppingCart.removeItem(index);
                },
              ),
            );
          },
        );
      },
    );
  }
}

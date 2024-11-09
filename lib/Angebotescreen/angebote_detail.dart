// lib/Angebotescreen/angebote_detail.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:eiscreme/cart/cartscreen.dart';
import 'angebote.dart';
import 'package:eiscreme/cart/shopping_cart.dart';

class AngebotDetail extends StatelessWidget {
  final Angebot angebot;

  const AngebotDetail({Key? key, required this.angebot}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final shoppingCart = Provider.of<ShoppingCart>(context, listen: false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(angebot.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Bild des Angebots
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                angebot.bild,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.broken_image,
                  size: 100,
                  color: Colors.grey,
                ),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
            const SizedBox(height: 16),
            // Name des Angebots
            Text(
              angebot.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Verkaufspreis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Verkaufspreis:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  '€${angebot.verkaufspreis}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Mietpreis
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mietpreis:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  '€${angebot.mietpreis}',
                  style: const TextStyle(fontSize: 18),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // Vermietet Status
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Status:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  angebot.vermietet ? 'Vermietet' : 'Verfügbar',
                  style: TextStyle(
                    fontSize: 18,
                    color: angebot.vermietet ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Buttons für Mieten und Kaufen
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: angebot.vermietet
                      ? null
                      : () {
                          // Mieten
                          shoppingCart.addItem(angebot, 'Mieten');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${angebot.name} wurde zum Einkaufswagen hinzugefügt (Mieten)!')),
                          );
                        },
                  child: const Text('Mieten'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: angebot.vermietet ? Colors.grey : Colors.blue,
                  ),
                ),
                ElevatedButton(
                  onPressed: angebot.vermietet
                      ? null
                      : () {
                          // Kaufen
                          shoppingCart.addItem(angebot, 'Kaufen');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${angebot.name} wurde zum Einkaufswagen hinzugefügt (Kaufen)!')),
                          );
                        },
                  child: const Text('Kaufen'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(150, 50),
                    backgroundColor: angebot.vermietet ? Colors.grey : Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

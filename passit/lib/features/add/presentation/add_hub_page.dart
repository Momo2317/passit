import 'package:flutter/material.dart';

/// Hinzufügen: Barcode, Foto, Manuell (placeholder hub).
class AddHubPage extends StatelessWidget {
  const AddHubPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hinzufügen')),
      body: const Center(
        child: Text('Barcode · Foto · Manuell (Platzhalter)'),
      ),
    );
  }
}

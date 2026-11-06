import 'package:flutter/material.dart';

/// Besitz: searchable list, filters (placeholder).
class BesitzPage extends StatelessWidget {
  const BesitzPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Besitz')),
      body: const Center(
        child: Text('Produktliste & Suche (Platzhalter)'),
      ),
    );
  }
}

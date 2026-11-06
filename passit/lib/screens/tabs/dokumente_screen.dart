import 'package:flutter/material.dart';

class DokumenteScreen extends StatelessWidget {
  const DokumenteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dokumente')),
      body: const Center(child: Text('Dokumentenbibliothek (MVP)')),
    );
  }
}

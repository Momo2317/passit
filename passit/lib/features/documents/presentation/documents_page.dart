import 'package:flutter/material.dart';

/// Dokumente: receipts, manuals (placeholder).
class DocumentsPage extends StatelessWidget {
  const DocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dokumente')),
      body: const Center(
        child: Text('Rechnungen & Anleitungen (Platzhalter)'),
      ),
    );
  }
}

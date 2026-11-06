import 'package:flutter/material.dart';

class HinzufuegenScreen extends StatelessWidget {
  const HinzufuegenScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hinzufügen')),
      body: const Center(child: Text('Erfassung (MVP)')),
    );
  }
}

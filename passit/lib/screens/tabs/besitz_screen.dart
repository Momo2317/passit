import 'package:flutter/material.dart';

class BesitzScreen extends StatelessWidget {
  const BesitzScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Besitz')),
      body: const Center(child: Text('Produktliste (MVP)')),
    );
  }
}

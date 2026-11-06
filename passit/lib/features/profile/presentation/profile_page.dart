import 'package:flutter/material.dart';

/// Profil: account, privacy, export (placeholder).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: const Center(
        child: Text('Konto & Datenschutz (Platzhalter)'),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../auth/auth_bloc.dart';

class ProfilScreen extends StatelessWidget {
  const ProfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: BlocBuilder<AuthBloc, PassitAuthState>(
        builder: (context, state) {
          final user = state.user;
          final email = user?.email;
          final id = user?.id;

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (email != null && email.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('E-Mail'),
                  subtitle: Text(email),
                )
              else if (id != null)
                ListTile(
                  leading: const Icon(Icons.badge_outlined),
                  title: const Text('Benutzer-ID'),
                  subtitle: Text(id),
                ),
              const SizedBox(height: 8),
              ListTile(
                leading: const Icon(Icons.download_outlined),
                title: const Text('Daten exportieren'),
                subtitle: const Text('Bald verfügbar'),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  'Account löschen',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                subtitle: const Text('Bald verfügbar'),
                onTap: () {},
              ),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () =>
                    context.read<AuthBloc>().add(const SignOutRequested()),
                icon: const Icon(Icons.logout),
                label: const Text('Abmelden'),
              ),
            ],
          );
        },
      ),
    );
  }
}

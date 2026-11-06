import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/add/presentation/add_hub_page.dart';
import '../features/dashboard/presentation/home_page.dart';
import '../features/documents/presentation/documents_page.dart';
import '../features/items/presentation/besitz_page.dart';
import '../features/profile/presentation/profile_page.dart';
import 'widgets/app_shell_scaffold.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AppShellScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/besitz',
              name: 'besitz',
              builder: (context, state) => const BesitzPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/add',
              name: 'add',
              builder: (context, state) => const AddHubPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/documents',
              name: 'documents',
              builder: (context, state) => const DocumentsPage(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              name: 'profile',
              builder: (context, state) => const ProfilePage(),
            ),
          ],
        ),
      ],
    ),
  ],
);

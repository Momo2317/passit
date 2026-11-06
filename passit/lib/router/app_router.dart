import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_bloc.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/tabs/besitz_screen.dart';
import '../screens/tabs/dokumente_screen.dart';
import '../screens/tabs/hinzufuegen_screen.dart';
import '../screens/tabs/home_screen.dart';
import '../screens/tabs/profil_screen.dart';
import '../shell/main_shell.dart';
import 'go_router_refresh_stream.dart';

/// Route paths used by redirects and tab branches.
abstract final class AppRoutes {
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const besitz = '/besitz';
  static const hinzufuegen = '/hinzufuegen';
  static const dokumente = '/dokumente';
  static const profil = '/profil';
}

GoRouter createAppRouter({
  required AuthBloc authBloc,
  required GoRouterRefreshStream refreshListenable,
  GlobalKey<NavigatorState>? navigatorKey,
}) {
  String? redirect(BuildContext context, GoRouterState state) {
    final loc = state.matchedLocation;
    final passitState = authBloc.state;
    final authRoutes = {AppRoutes.login, AppRoutes.register};

    if (passitState.status == AuthStatus.unknown ||
        passitState.status == AuthStatus.loading) {
      return null;
    }

    final loggedIn = passitState.isAuthenticated;
    final atAuth = authRoutes.contains(loc);

    if (!loggedIn && !atAuth) {
      return AppRoutes.login;
    }
    if (loggedIn && atAuth) {
      return AppRoutes.home;
    }
    return null;
  }

  return GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: refreshListenable,
    redirect: redirect,
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.besitz,
                name: 'besitz',
                builder: (context, state) => const BesitzScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.hinzufuegen,
                name: 'hinzufuegen',
                builder: (context, state) => const HinzufuegenScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dokumente,
                name: 'dokumente',
                builder: (context, state) => const DokumenteScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profil,
                name: 'profil',
                builder: (context, state) => const ProfilScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

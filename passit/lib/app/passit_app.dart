import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../auth/auth_bloc.dart';
import '../config/app_config.dart';
import '../router/app_router.dart';
import '../router/go_router_refresh_stream.dart';

class PassitApp extends StatelessWidget {
  const PassitApp({super.key, required this.config});

  final AppConfig config;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(config: config)..add(const AuthStarted()),
      child: const _PassitAppView(),
    );
  }
}

class _PassitAppView extends StatefulWidget {
  const _PassitAppView();

  @override
  State<_PassitAppView> createState() => _PassitAppViewState();
}

class _PassitAppViewState extends State<_PassitAppView> {
  late final GoRouter _router;
  late final GoRouterRefreshStream _authRefresh;

  @override
  void initState() {
    super.initState();
    final authBloc = context.read<AuthBloc>();
    _authRefresh = GoRouterRefreshStream(authBloc.stream);
    _router = createAppRouter(
      authBloc: authBloc,
      refreshListenable: _authRefresh,
    );
  }

  @override
  void dispose() {
    _authRefresh.dispose();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'PASSIT',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

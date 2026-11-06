import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:gotrue/gotrue.dart' as gotrue;
import 'package:supabase_flutter/supabase_flutter.dart';

import '../config/app_config.dart';

part 'auth_event.dart';
part 'auth_state.dart';

/// Manages auth via Supabase and mirrors [User] / session state for the UI.
///
/// Subscribes to [SupabaseAuthClient.onAuthStateChange] when Supabase is
/// initialized; otherwise stays [AuthStatus.unauthenticated].
class AuthBloc extends Bloc<AuthEvent, PassitAuthState> {
  AuthBloc({required this._config, SupabaseClient? supabase})
    : _client = supabase,
      super(const PassitAuthState.initial()) {
    on<AuthStarted>(_onStarted);
    on<AuthSessionChanged>(_onSessionChanged);
    on<SignInRequested>(_onSignIn);
    on<SignUpRequested>(_onSignUp);
    on<SignOutRequested>(_onSignOut);
    on<ClearAuthError>(_onClearError);
  }

  final AppConfig _config;
  final SupabaseClient? _client;
  StreamSubscription<gotrue.AuthState>? _authSubscription;

  SupabaseClient? get _activeClient =>
      _client ?? (_config.hasSupabaseConfig ? Supabase.instance.client : null);

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<PassitAuthState> emit,
  ) async {
    final client = _activeClient;
    if (client == null) {
      emit(const PassitAuthState(status: AuthStatus.unauthenticated));
      return;
    }

    emit(state.copyWith(status: AuthStatus.loading, clearError: true));

    final initial = _mapSession(client.auth.currentSession);
    emit(initial);

    await _authSubscription?.cancel();
    _authSubscription = client.auth.onAuthStateChange.listen(
      (gotrue.AuthState data) => add(AuthSessionChanged(session: data.session)),
    );
  }

  void _onSessionChanged(
    AuthSessionChanged event,
    Emitter<PassitAuthState> emit,
  ) {
    emit(_mapSession(event.session));
  }

  PassitAuthState _mapSession(Session? session) {
    final user = session?.user;
    if (user != null) {
      return PassitAuthState(status: AuthStatus.authenticated, user: user);
    }
    return const PassitAuthState(status: AuthStatus.unauthenticated);
  }

  Future<void> _onSignIn(
    SignInRequested event,
    Emitter<PassitAuthState> emit,
  ) async {
    final client = _activeClient;
    if (client == null) {
      emit(state.copyWith(errorMessage: 'Supabase ist nicht konfiguriert.'));
      return;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await client.auth.signInWithPassword(
        email: event.email.trim(),
        password: event.password,
      );
      emit(state.copyWith(isSubmitting: false));
    } on AuthException catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignUp(
    SignUpRequested event,
    Emitter<PassitAuthState> emit,
  ) async {
    final client = _activeClient;
    if (client == null) {
      emit(state.copyWith(errorMessage: 'Supabase ist nicht konfiguriert.'));
      return;
    }
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await client.auth.signUp(
        email: event.email.trim(),
        password: event.password,
      );
      emit(state.copyWith(isSubmitting: false));
    } on AuthException catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.message));
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, errorMessage: e.toString()));
    }
  }

  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<PassitAuthState> emit,
  ) async {
    final client = _activeClient;
    if (client == null) {
      emit(const PassitAuthState(status: AuthStatus.unauthenticated));
      return;
    }
    try {
      await client.auth.signOut();
    } catch (_) {
      // Still treat as signed out locally.
    }
    emit(const PassitAuthState(status: AuthStatus.unauthenticated));
  }

  void _onClearError(ClearAuthError event, Emitter<PassitAuthState> emit) {
    emit(state.copyWith(clearError: true));
  }
}

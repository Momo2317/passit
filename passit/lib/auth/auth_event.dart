part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Loads current session and subscribes to [SupabaseAuthClient.onAuthStateChange].
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

class AuthSessionChanged extends AuthEvent {
  const AuthSessionChanged({this.session});

  final Session? session;

  @override
  List<Object?> get props => [session];
}

class SignInRequested extends AuthEvent {
  const SignInRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignUpRequested extends AuthEvent {
  const SignUpRequested({required this.email, required this.password});

  final String email;
  final String password;

  @override
  List<Object?> get props => [email, password];
}

class SignOutRequested extends AuthEvent {
  const SignOutRequested();
}

class ClearAuthError extends AuthEvent {
  const ClearAuthError();
}

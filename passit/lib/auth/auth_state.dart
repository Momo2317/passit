part of 'auth_bloc.dart';

enum AuthStatus { unknown, loading, authenticated, unauthenticated }

/// UI/auth state for [AuthBloc] (named to avoid clashing with gotrue's [AuthState]).
class PassitAuthState extends Equatable {
  const PassitAuthState({
    required this.status,
    this.user,
    this.errorMessage,
    this.isSubmitting = false,
  });

  const PassitAuthState.initial()
    : status = AuthStatus.unknown,
      user = null,
      errorMessage = null,
      isSubmitting = false;

  final AuthStatus status;
  final User? user;
  final String? errorMessage;
  final bool isSubmitting;

  bool get isAuthenticated =>
      status == AuthStatus.authenticated && user != null;

  PassitAuthState copyWith({
    AuthStatus? status,
    User? user,
    String? errorMessage,
    bool? isSubmitting,
    bool clearError = false,
  }) {
    return PassitAuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSubmitting: isSubmitting ?? this.isSubmitting,
    );
  }

  @override
  List<Object?> get props => [status, user?.id, errorMessage, isSubmitting];
}

import 'package:flutter_bloc/flutter_bloc.dart';

/// Minimal global cubit so Bloc is wired at app start (feature Blocs follow later).
enum AppReadyState { booting, ready }

class AppCubit extends Cubit<AppReadyState> {
  AppCubit() : super(AppReadyState.booting) {
    emit(AppReadyState.ready);
  }
}

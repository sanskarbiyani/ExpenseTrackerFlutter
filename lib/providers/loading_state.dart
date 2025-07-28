import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/loading_state.dart';

class LoadingNotifier extends StateNotifier<LoadingState> {
  LoadingNotifier() : super(const Idle());

  void startLoading() {
    state = const Loading();
  }

  void setSucess() {
    state = const LoadingSuccess();
  }

  void setError(String errorMessage) {
    state = LoadingError(errorMessage);
  }

  void setIdle() {
    state = const Idle();
  }
}

final loadingProvider = StateNotifierProvider<LoadingNotifier, LoadingState>(
  (ref) => LoadingNotifier(),
);

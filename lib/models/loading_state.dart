sealed class LoadingState {
  const LoadingState();
}

class Loading extends LoadingState {
  const Loading();
}

class LoadingError extends LoadingState {
  final String errorMessage;
  const LoadingError(this.errorMessage);
}

class LoadingSuccess extends LoadingState {
  const LoadingSuccess();
}

class Idle extends LoadingState {
  const Idle();
}

import 'package:message_expense_tracker/models/users.dart';

sealed class UserState {
  const UserState();
}

class UserInitial extends UserState {
  const UserInitial();
}

class UserLoading extends UserState {
  const UserLoading();
}

class UserError extends UserState {
  final String errorMessage;
  const UserError(this.errorMessage);
}

class UserPresent extends UserState {
  final LoggedInUser user;
  const UserPresent(this.user);
}

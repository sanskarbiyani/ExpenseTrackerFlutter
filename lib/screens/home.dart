import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/user_state.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/providers/user.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider.notifier);
    final userState = ref.watch(userProvider);
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: auth.logout, icon: Icon(Icons.logout))],
      ),
      body: Center(
        child:
            (userState is UserPresent)
                ? Text(userState.user.username)
                : Text("Home Screen"),
      ),
    );
  }
}

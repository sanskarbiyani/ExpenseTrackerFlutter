import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/providers/accounts.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/screens/auth.dart';
import 'package:message_expense_tracker/widgets/drawer.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  @override
  void initState() {
    super.initState();

    // Defer work to after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authState = ref.read(authProvider);
      if (authState is UnAuthenticated) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
        return;
      }

      final token = (authState as Authenticated).accessToken;
      final accountList = ref.read(accountsProvider(token));

      if (accountList.isEmpty) {
        final notifier = ref.read(accountsProvider(token).notifier);
        notifier.fetchAccounts();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState is! Authenticated) {
      return const SizedBox(); // Safe fallback UI
    }

    final token = authState.accessToken;
    final accountList = ref.watch(accountsProvider(token));

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      drawer: const SideDrawer(currentScreen: "Accounts"),
      body: ListView.builder(
        itemCount: accountList.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(accountList[index].name));
        },
      ),
    );
  }
}

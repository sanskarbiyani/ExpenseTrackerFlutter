import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/account.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/providers/accounts.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/screens/auth.dart';
import 'package:message_expense_tracker/widgets/drawer.dart';

class AccountScreen extends ConsumerWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var authState = ref.watch(authProvider);
    if (authState is UnAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen()));
    }

    String token = (authState as Authenticated).accessToken;
    var accountNotifier = ref.read(accountsProvider(token).notifier);
    List<Account> accountList = ref.watch(accountsProvider(token));
    if (accountList.isEmpty) {
      accountNotifier.fetchAccounts();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Accounts')),
      drawer: SideDrawer(currentScreen: "Accounts"),
      body: ListView.builder(
        itemCount: accountList.length,
        itemBuilder: (context, index) {
          return ListTile(title: Text(accountList[index].name));
        },
      ),
    );
  }
}

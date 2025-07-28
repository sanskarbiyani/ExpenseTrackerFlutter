import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/providers/accounts.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/screens/auth.dart';
import 'package:message_expense_tracker/screens/transaction_list.dart';
import 'package:message_expense_tracker/widgets/add_account.dart';
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

  void _openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return FractionallySizedBox(
          heightFactor: 0.7, // 70% of screen height
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: AddAccount(), // your custom widget
          ),
        );
      },
    );
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
      floatingActionButton: FloatingActionButton(
        onPressed: _openBottomSheet,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: accountList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(accountList[index].name),
            subtitle: Text(accountList[index].description),
            leading: Icon(Icons.flight),
            trailing: DefaultTextStyle(
              style: Theme.of(
                context,
              ).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.currency_rupee),
                  Text(accountList[index].balance.toString()),
                ],
              ),
            ),
            onTap: () async {
              await Future.delayed(const Duration(milliseconds: 100));
              if (!context.mounted) return;
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => const TransactionListScreen(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

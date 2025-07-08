import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/models/loading_state.dart';
import 'package:message_expense_tracker/models/transaction.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/providers/transaction.dart';
import 'package:message_expense_tracker/screens/auth.dart';

class TransactionList extends ConsumerStatefulWidget {
  const TransactionList({super.key, required this.selectedMonth});

  final String selectedMonth;

  @override
  ConsumerState<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends ConsumerState<TransactionList> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final authState = ref.read(authProvider);

      if (authState is Authenticated) {
        ref
            .read(transactionProvider(authState.accessToken).notifier)
            .fetchTransactions(widget.selectedMonth);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState is UnAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen()));
    }

    final transactionList = ref.watch(
      transactionProvider((authState as Authenticated).accessToken),
    );
    final loadingState = ref.watch(loadingProvider);

    Widget content = SliverToBoxAdapter(
      child: Center(child: const CircularProgressIndicator()),
    );
    if (loadingState is LoadingError) {
      content = SliverToBoxAdapter(
        child: Center(child: Text(loadingState.errorMessage)),
      );
    }
    if (loadingState is LoadingSuccess) {
      content = SliverList(
        delegate: SliverChildBuilderDelegate(
          (ctx, index) => ListTile(
            title: Text(transactionList[index].title),
            subtitle: Text(transactionList[index].description),
            leading: Icon(Icons.attach_money),
            trailing: DefaultTextStyle(
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontWeight: FontWeight.bold,
                color:
                    transactionList[index].transactionType ==
                            TransactionType.income
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.error,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.currency_rupee,
                    color:
                        transactionList[index].transactionType ==
                                TransactionType.income
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error,
                  ),
                  Text(transactionList[index].amount.toString()),
                ],
              ),
            ),
          ),
          childCount: transactionList.length,
        ),
      );
    }

    return content;
  }
}

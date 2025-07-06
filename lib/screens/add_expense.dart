import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/loading_state.dart';
import 'package:message_expense_tracker/models/transaction.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/providers/transaction.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descInputController = TextEditingController();

  List<String>? _accountList;
  List<String>? _tagList;
  String? _selectedAccount;
  String? _selectedTag;
  TransactionType _selectedTransactionType = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    setState(() {
      _accountList = ['Cash', 'BOB', 'ICICI'];
      _tagList = ['Travel', 'Food', 'Health'];
      _selectedAccount = 'Cash';
      _selectedTag = 'Travel';
    });
  }

  void _addExpense() async {
    final amount = double.tryParse(_amountController.text);
    final desc = _descInputController.text;
    if (amount == null) {
      return;
    }
    Transaction transaction = Transaction(
      amount: amount,
      description: desc,
      transactionType: _selectedTransactionType,
      title: '',
    );

    String msg = await ref
        .read(transactionProvider.notifier)
        .addTransaction(transaction);

    var loadingState = ref.watch(loadingProvider);
    if (!mounted) return;

    if (loadingState is LoadingError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(loadingState.errorMessage),
          backgroundColor: Theme.of(context).colorScheme.errorContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          duration: Duration(seconds: 3),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          duration: Duration(seconds: 3),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    var loading = ref.watch(loadingProvider);
    if (_accountList == null || _tagList == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                // Account dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedAccount,
                          items:
                              _accountList!
                                  .map(
                                    (tag) => DropdownMenuItem(
                                      value: tag,
                                      child: Text(tag),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedAccount = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),
                // Tag dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTag,
                          items:
                              _tagList!
                                  .map(
                                    (tag) => DropdownMenuItem(
                                      value: tag,
                                      child: Text(tag),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedTag = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            DropdownButton<TransactionType>(
              value: _selectedTransactionType,
              items:
                  TransactionType.values
                      .map(
                        (type) => DropdownMenuItem<TransactionType>(
                          value: type,
                          child: Text(type.displayName),
                        ),
                      )
                      .toList(),
              onChanged: (TransactionType? value) {
                if (value == null) return;
                setState(() {
                  _selectedTransactionType = value;
                });
              },
            ),
            SizedBox(height: 50),
            SizedBox(
              width: 200,
              child: TextField(
                controller: _amountController,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '00.00',
                  prefixIcon: Icon(Icons.currency_rupee),
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: Theme.of(context).textTheme.displayMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 50),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250, minWidth: 130),
              child: IntrinsicWidth(
                child: TextField(
                  maxLines: 3,
                  minLines: 1,
                  controller: _descInputController,
                  decoration: InputDecoration(
                    hintText: 'Description',
                    filled: true,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (loading is Loading) ? null : _addExpense,
        child:
            (loading is Loading)
                ? const CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                )
                : Icon(Icons.arrow_right_alt),
      ),
    );
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }
}

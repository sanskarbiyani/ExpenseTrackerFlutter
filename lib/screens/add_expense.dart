import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/account.dart';
import 'package:message_expense_tracker/models/auth_state.dart';
import 'package:message_expense_tracker/models/loading_state.dart';
import 'package:message_expense_tracker/models/transaction.dart';
import 'package:message_expense_tracker/providers/accounts.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/providers/transaction.dart';
import 'package:message_expense_tracker/screens/auth.dart';
import 'package:message_expense_tracker/services/common_service.dart';

import '../providers/auth.dart';

class AddExpenseScreen extends ConsumerStatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  ConsumerState<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends ConsumerState<AddExpenseScreen> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descInputController = TextEditingController();
  final TextEditingController _titleInputController = TextEditingController();

  List<Account> _accountList = [];
  List<String> _tagList = [];
  Account? _selectedAccount;
  String? _selectedTag;
  String _token = "";
  TransactionType _selectedTransactionType = TransactionType.expense;

  @override
  void initState() {
    super.initState();
    setState(() {
      _tagList = ['Travel', 'Food', 'Health'];
      _selectedTag = 'Travel';
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAccounts(context);
    });
  }

  void _showSnackBar(String text, {bool navigationRequired = false}) {
    if (navigationRequired) {
      Navigator.of(context).pop();
    }
    Future.delayed(Duration.zero, () {
      CommonService.showSnackBar(text);
    });
  }

  void _loadAccounts(BuildContext ctx) {
    final authState = ref.read(authProvider);
    if (authState is UnAuthenticated) {
      Navigator.of(
        ctx,
      ).pushReplacement(MaterialPageRoute(builder: (context) => AuthScreen()));
    }
    final appToken = (authState as Authenticated).accessToken;
    setState(() {
      _token = appToken;
    });

    ref.read(accountsProvider(appToken).notifier).fetchAccounts();
  }

  void _addExpense() async {
    final amount = double.tryParse(_amountController.text);
    final desc = _descInputController.text;
    final title = _titleInputController.text;

    if (amount == null) {
      _showSnackBar("Amount field cannot empty");
      return;
    } else if (desc.isEmpty) {
      _showSnackBar("Description cannot tbe empty");
      return;
    } else if (_selectedAccount == null) {
      _showSnackBar("Selected account cannot be null");
      return;
    }

    final selectedAccountId = _selectedAccount!.id;
    if (selectedAccountId == null) {
      _showSnackBar("Selected account id cannot be null");
      return;
    }
    Transaction transaction = Transaction(
      amount: amount,
      description: desc,
      transactionType: _selectedTransactionType,
      accountId: selectedAccountId,
      title: title.isEmpty ? '' : title,
    );

    final authState = ref.read(authProvider);
    if (authState is UnAuthenticated) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => AuthScreen()));
    }
    final token = (authState as Authenticated).accessToken;
    String msg = await ref
        .read(transactionProvider(token).notifier)
        .addTransaction(transaction);

    var loadingState = ref.watch(loadingProvider);
    if (!mounted) return;

    if (loadingState is LoadingError) {
      _showSnackBar(loadingState.errorMessage);
    } else {
      _showSnackBar(msg, navigationRequired: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    var loading = ref.watch(loadingProvider);
    final accountList = ref.watch(accountsProvider(_token));

    if (loading is Loading || accountList.isEmpty || _tagList.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }

    if (loading is LoadingSuccess && _accountList.isEmpty) {
      _accountList = accountList;
      _selectedAccount ??= accountList.first; // only set if null
    }

    return Scaffold(
      appBar: AppBar(title: Text("Add Transaction")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Row(
              children: [
                // Account dropdown
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<Account>(
                          value: _selectedAccount,
                          style: Theme.of(context).textTheme.titleLarge,
                          padding: const EdgeInsets.all(5),
                          isExpanded: true,
                          items:
                              _accountList
                                  .map(
                                    (account) => DropdownMenuItem<Account>(
                                      value: account,
                                      child: Text(
                                        account.name,
                                        textAlign: TextAlign.center,
                                        overflow:
                                            TextOverflow
                                                .ellipsis, // prevent wrapping
                                        maxLines: 1, // single line
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontSize: 18, // smaller font
                                        ),
                                      ),
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
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTag,
                          style: Theme.of(context).textTheme.titleLarge,
                          padding: const EdgeInsets.all(5),
                          isExpanded: true,
                          items:
                              _tagList
                                  .map(
                                    (tag) => DropdownMenuItem(
                                      value: tag,
                                      child: Text(
                                        tag,
                                        textAlign:
                                            TextAlign
                                                .center, // prevent wrapping
                                        maxLines: 1, // single line
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleMedium?.copyWith(
                                          fontSize: 18, // smaller font
                                        ),
                                      ),
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
            Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Align(
                alignment: Alignment.center,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TransactionType>(
                    value: _selectedTransactionType,
                    style: Theme.of(context).textTheme.titleLarge,
                    padding: const EdgeInsets.all(5),
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
                ),
              ),
            ),
            SizedBox(height: 80),
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250, minWidth: 130),
              child: TextField(
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
                controller: _titleInputController,
                decoration: InputDecoration(
                  hintText: 'Enter title',
                  filled: true,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
            IntrinsicWidth(
              child: TextField(
                controller: _amountController,
                autofocus: true,
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  hintText: '00.00',
                  prefix: Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      Icons.currency_rupee,
                      size:
                          Theme.of(context).textTheme.displaySmall?.fontSize ??
                          24,
                    ),
                  ),
                  isDense: true, // still keeps it compact
                  border: InputBorder.none,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: Theme.of(
                  context,
                ).textTheme.displayLarge!.copyWith(fontWeight: FontWeight.bold),
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
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'Enter description',
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
                  style: Theme.of(context).textTheme.bodyLarge,
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

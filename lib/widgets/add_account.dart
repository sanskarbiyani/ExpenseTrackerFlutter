import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:message_expense_tracker/models/account.dart';
import 'package:message_expense_tracker/models/loading_state.dart';
import 'package:message_expense_tracker/providers/accounts.dart';
import 'package:message_expense_tracker/providers/loading_state.dart';
import 'package:message_expense_tracker/screens/auth.dart';
import 'package:message_expense_tracker/services/common_service.dart';

class AddAccount extends ConsumerStatefulWidget {
  const AddAccount({super.key});

  @override
  ConsumerState<AddAccount> createState() => _AddAccount();
}

class _AddAccount extends ConsumerState<AddAccount> {
  final _formKey = GlobalKey<FormState>();
  String? _accountName, _accountDesc;
  double? _startingBalance;

  void _addAccount() async {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    _formKey.currentState!.save();

    final token = CommonService.getToken(ref);
    if (token.isEmpty) {
      Navigator.of(
        context,
      ).pushReplacement(MaterialPageRoute(builder: (ctx) => AuthScreen()));
    }

    Account newAcc = Account(
      name: _accountName!,
      description: _accountDesc!,
      balance: _startingBalance!,
    );
    final accountNotifier = ref.read(accountsProvider(token).notifier);
    bool isSuccess = await accountNotifier.addAccount(newAcc);
    if (!mounted) return;
    if (isSuccess) {
      CommonService.showSnackBar("$_accountName added successfully");
      Navigator.of(context).pop();
    } else {
      CommonService.showSnackBar(
        "Could not add account. Please try again later",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final loadingState = ref.watch(loadingProvider);

    if (loadingState is Loading) {
      return Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Add Account",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 40),
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Account Name",
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Account name cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _accountName = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  textInputAction: TextInputAction.next,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Account Description",
                    prefixIcon: Icon(Icons.account_balance),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Account Description cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _accountDesc = value;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  textInputAction: TextInputAction.done,
                  decoration: InputDecoration(
                    labelText: "Starting Balance",
                    prefixIcon: Icon(Icons.currency_rupee),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Starting balance cannot be empty";
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _startingBalance = double.parse(value!);
                  },
                  onFieldSubmitted: (_) => _addAccount(),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
          ElevatedButton(onPressed: _addAccount, child: Text("Add Account")),
        ],
      ),
    );
  }
}

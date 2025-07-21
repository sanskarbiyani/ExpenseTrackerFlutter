import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:message_expense_tracker/models/user_state.dart';
import 'package:message_expense_tracker/models/users.dart';
import 'package:message_expense_tracker/providers/auth.dart';
import 'package:message_expense_tracker/providers/user.dart';
import 'package:message_expense_tracker/screens/add_expense.dart';
import 'package:message_expense_tracker/screens/transaction_list.dart';
import 'package:message_expense_tracker/widgets/drawer.dart';
import 'package:message_expense_tracker/widgets/home_screen_filter.dart';
import 'package:message_expense_tracker/widgets/summary_card.dart';
import 'package:message_expense_tracker/widgets/transaction_list.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _selectValue = "Total balance";
  String _selectedMonth = DateFormat.MMM().format(DateTime.now());
  double _headNumber = 0;
  bool _isExpenseSelected = true;
  LoggedInUser? _userData;
  bool _isFirstChange = true;

  void toggleSelectedPill(bool isExpenseSelected) {
    setState(() {
      _isExpenseSelected = isExpenseSelected;
    });
  }

  void updateSelectedMonth(String selectedMonth) {
    setState(() {
      _selectedMonth = selectedMonth;
    });
  }

  void _updateHeadNumber() {
    if (_userData == null) return;

    setState(() {
      if (_selectValue == 'Credit') {
        _headNumber = _userData!.credit;
      } else if (_selectValue == 'Debit') {
        _headNumber = _userData!.debit;
      } else {
        _headNumber = _userData!.balance;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authProvider.notifier);
    final userState = ref.watch(userProvider);
    _userData = (userState as UserPresent).user;
    final dropDownItems = ["Total balance", "Credit", "Debit"];

    if (_isFirstChange) {
      _updateHeadNumber();
      _isFirstChange = false;
    }

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Icon(Icons.currency_rupee, size: 28),
              Text(
                _headNumber.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 45,
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            onPressed: auth.logout,
            icon: Icon(Icons.logout, size: 30),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40.0),
          child: Expanded(
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectValue,
                isDense: true,
                items:
                    dropDownItems
                        .map(
                          (item) =>
                              DropdownMenuItem(value: item, child: Text(item)),
                        )
                        .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectValue = value!;
                    _updateHeadNumber();
                  });
                },
              ),
            ),
          ),
        ),
      ),
      drawer: SideDrawer(currentScreen: "Home"),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8.0,
                horizontal: 10.0,
              ),
              child: Column(
                children: [
                  HomeScreenFilter(
                    isExpenseSelected: _isExpenseSelected,
                    selectedMonth: _selectedMonth,
                    toggleExpense: toggleSelectedPill,
                    updateSelectedMonth: updateSelectedMonth,
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 250,
                    decoration: BoxDecoration(color: Colors.grey),
                  ),
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      SummaryCard(title: 'Day', amount: 20),
                      SizedBox(width: 10),
                      SummaryCard(title: 'Week', amount: 200),
                      SizedBox(width: 10),
                      SummaryCard(title: 'Month', amount: 2000),
                    ],
                  ),
                  SizedBox(height: 15),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const TransactionListScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.all(0),
                        minimumSize: Size(0, 0),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text("All Expenses"),
                          SizedBox(width: 3),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          TransactionList(selectedMonth: _selectedMonth),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (ctx) => AddExpenseScreen()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

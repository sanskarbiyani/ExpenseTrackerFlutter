import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HomeScreenFilter extends StatefulWidget {
  const HomeScreenFilter({
    super.key,
    required this.isExpenseSelected,
    required this.selectedMonth,
    required this.toggleExpense,
    required this.updateSelectedMonth,
  });

  final bool isExpenseSelected;
  final String selectedMonth;
  final Function(bool status) toggleExpense;
  final Function(String selectedMonth) updateSelectedMonth;

  @override
  createState() => _HomeScreenFilterState();
}

class _HomeScreenFilterState extends State<HomeScreenFilter> {
  final _monthList = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];
  String _currMonth = DateFormat.MMM().format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(50),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Expenses
              GestureDetector(
                onTap: () => widget.toggleExpense(true),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        widget.isExpenseSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Expenses',
                    style: TextStyle(
                      color:
                          widget.isExpenseSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Income
              GestureDetector(
                onTap: () => widget.toggleExpense(false),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color:
                        !widget.isExpenseSelected
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Text(
                    'Income',
                    style: TextStyle(
                      color:
                          !widget.isExpenseSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(
                                context,
                              ).colorScheme.onSecondaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Text(_currMonth),
            ],
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 5),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondaryContainer,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Align(
              alignment: Alignment.center,
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _currMonth,
                  items:
                      _monthList
                          .map(
                            (month) => DropdownMenuItem<String>(
                              value: month,
                              child: Text(month),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    setState(() {
                      _currMonth = value!;
                    });
                    widget.updateSelectedMonth(_currMonth);
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

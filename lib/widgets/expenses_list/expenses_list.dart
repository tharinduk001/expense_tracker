import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expense_item.dart';
import 'package:flutter/material.dart';

class ExpensesList extends StatelessWidget {
  final List<Expense> expenses;
  final void Function(Expense expense) onRemoveExpense;
  final void Function(Expense expense)? openEditMode;

  const ExpensesList(
      {super.key,
      required this.expenses,
      required this.onRemoveExpense,
      this.openEditMode});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(expenses[index]),
        onDismissed: (direction) {
          onRemoveExpense(expenses[index]);
        },
        background: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Container(
            color: Theme.of(context).colorScheme.error.withOpacity(0.75),
            margin: EdgeInsets.symmetric(
                horizontal: Theme.of(context).cardTheme.margin!.horizontal),
          ),
        ),
        child: GestureDetector(
          child: ExpenseItem(expense: expenses[index]),
          onTap: () {
            if (openEditMode == null) {
              return;
            }
            openEditMode!(expenses[index]);
          },
        ),
      ),
    );
  }
}

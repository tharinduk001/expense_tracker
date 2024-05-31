import 'package:expense_tracker/widgets/charts/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: 'Flutter course',
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work),
    Expense(
        title: 'Cinema',
        amount: 15.66,
        date: DateTime.now(),
        category: Category.leisure),
  ];

  void _openAddExpemseOverlay(Expense? expense) {
    showModalBottomSheet(
      showDragHandle: true,
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (context) => NewExpense(
        onAddExpense: _addExpense,
        onRemoveExpense: _removeExpenseOnUpdate,
        expenseIfHave: expense,
      ),
    );
  }

  void _addExpense(Expense expense, Expense? updatedExpense) {
    if (updatedExpense == null) {
      setState(() {
        _registeredExpenses.add(expense);
      });
    } else {
      final expenseIndex = _registeredExpenses.indexOf(updatedExpense);
      setState(() {
        _registeredExpenses.insert(expenseIndex, expense);
      });
    }
  }

  void _removeExpenseOnUpdate(Expense expense , Expense? updatedExpense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Updated."),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              if (updatedExpense != null){
                 setState(() {
                _registeredExpenses.insert(expenseIndex-1, expense);
                _registeredExpenses.remove(updatedExpense);
              });
              }
              // setState(() {
              //   _registeredExpenses.insert(expenseIndex-1, expense);
              // });
            }),
      ),
    );
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text("Expense Deleted."),
        action: SnackBarAction(
            label: 'Undo',
            onPressed: () {
              setState(() {
                _registeredExpenses.insert(expenseIndex, expense);
              });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text("No Expenses Found! Try Adding One"),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        onRemoveExpense: _removeExpense,
        openEditMode: _openAddExpemseOverlay,
        expenses: _registeredExpenses,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Expense Tracker",
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        actions: [
          IconButton(
              onPressed: () {
                _openAddExpemseOverlay(null);
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Column(
        children: [
        Chart(expenses: _registeredExpenses),
         Expanded(child: mainContent)],
      ),
    );
  }
}

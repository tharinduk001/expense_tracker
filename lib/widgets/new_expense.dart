
import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';

class NewExpense extends StatefulWidget {
  final void Function(Expense expense , Expense? updatedExpense) onAddExpense;
  final void Function(Expense expense , Expense? toUpdate) onRemoveExpense;
  final Expense? expenseIfHave;
  const NewExpense({
    super.key,
    required this.onAddExpense,
    this.expenseIfHave,
    required this.onRemoveExpense,
  });

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  Category _selectedCategory = Category.leisure;
  bool editMode = false;
  DateTime? _selectedDate;

  void _presentDatePicker() async {
    DateTime now = DateTime.now();
    DateTime firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
        context: context,
        firstDate: firstDate,
        lastDate: now,
        initialDate: now);
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData(bool editmode) {
    // void _submitExpenseData({bool? editMode,  Expense? expense}) {

    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Invalid Input"),
          content: const Text("Please add correct details to every fields."),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Ok"))
          ],
        ),
      );
      return;
    }
    if (editmode != true) {
      widget.onAddExpense(Expense(
          title: _titleController.text,
          amount: enteredAmount,
          date: _selectedDate!,
          category: _selectedCategory), null);
      Navigator.pop(context);
    } else {
      if (widget.expenseIfHave != null) {

        Expense newExpense  = Expense(
            title: _titleController.text,
            amount: enteredAmount,
            date: _selectedDate!,
            category: _selectedCategory);

        widget.onAddExpense(newExpense, widget.expenseIfHave!);
       widget.onRemoveExpense(widget.expenseIfHave! ,newExpense);
        Navigator.pop(context);
      } else {
        return;
      }
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
    if (widget.expenseIfHave != null) {
      editMode = true;
      _titleController.text = widget.expenseIfHave!.title;
      _amountController.text = widget.expenseIfHave!.amount.toString();
      _selectedDate = widget.expenseIfHave!.date;
      _selectedCategory = widget.expenseIfHave!.category;
    } else {
      editMode = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          TextField(
            controller: _titleController,
            maxLength: 50,
            decoration: const InputDecoration(
              label: Text("Expense"),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      label: Text("Amount"), prefixText: '\$ '),
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        textAlign: TextAlign.center,
                        _selectedDate == null
                            ? 'No Date Selected'
                            : formatter.format(_selectedDate!),
                      ),
                    ),
                    IconButton(
                        onPressed: _presentDatePicker,
                        icon: const Icon(Icons.calendar_month))
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton(
                  value: _selectedCategory,
                  items: Category.values
                      .map((singleCategory) => DropdownMenuItem(
                          value: singleCategory,
                          child: Text(singleCategory.name.toUpperCase())))
                      .toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }
                    setState(() {
                      _selectedCategory = value;
                    });
                  },
                ),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel")),
                ElevatedButton(
                    onPressed: () {
                      _submitExpenseData(editMode);
                      // _submitExpenseData(editMode: editMode, expense: widget.expenseIfHave!);
                    },
                    child: editMode
                        ? const Text("Edit Expense")
                        : const Text("Save Expense")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

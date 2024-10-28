import 'package:advance_expense_tracker/data/dummy_data.dart';
import 'package:advance_expense_tracker/screns/home/views/widget/transaction_item.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';

class Transaction extends StatelessWidget {
  final List<Expense> expenses;
  const Transaction(this.expenses, {super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: expenses.length,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TransactionItem(data: expenses[index],),
      ),
    );
  }
}

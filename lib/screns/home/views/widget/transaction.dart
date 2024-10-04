import 'package:advance_expense_tracker/data/dummy_data.dart';
import 'package:advance_expense_tracker/screns/home/views/widget/transaction_item.dart';
import 'package:flutter/material.dart';

class Transaction extends StatefulWidget {
  const Transaction({super.key});

  @override
  State<Transaction> createState() => _TransactionState();
}

class _TransactionState extends State<Transaction> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (ctx, index) => Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: TransactionItem(data: dummyData[index],),
      ),
    );
  }
}

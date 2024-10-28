import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  final Expense data;

  const TransactionItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(data.category.color),
                      ),
                    ),
                    Image.asset(
                      'assets/${data.category.icon}.png',
                      scale: 14,
                      color: Colors.white,
                    )
                    // data['icon'] // fetch icon
                  ],
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  data.category.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '-\$ ${data.amount.toString()}.00',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(data.date),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

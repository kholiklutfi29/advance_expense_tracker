import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final List<String> categoryItem;
  final String iconSelected;
  final Function(String) onSelected;

  const CategoryItem({
    super.key,
    required this.categoryItem,
    required this.iconSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onSelected(categoryItem[0]);
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              width: 3,
              color:
                  iconSelected == categoryItem[0] ? Colors.green : Colors.grey),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/${categoryItem[0]}.png',
              width: 50,
              height: 50,
            ),
            Text(
              categoryItem[1],
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

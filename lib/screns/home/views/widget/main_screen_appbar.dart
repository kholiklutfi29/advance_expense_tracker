import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreenAppBar extends StatelessWidget {
  const MainScreenAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.yellow[700],
                  ),
                ),
                Icon(
                  CupertinoIcons.person_fill,
                  color: Colors.yellow[900],
                )
              ],
            ),
            const SizedBox(
              width: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Welcome!",
                  style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).colorScheme.outline,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  "John Doe",
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(CupertinoIcons.settings),
        )
      ],
    );
  }
}

import 'package:advance_expense_tracker/screns/home/views/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense Tracker',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          surface: Colors.grey.shade100,
          onSurface: Colors.black,
          primary: const Color(0xFF00B2F7),
          secondary: const Color(0xFFE064F7),
          tertiary: const Color(0xFFFF8D6C),
          outline: Colors.grey,
        ),
        textTheme: GoogleFonts.outfitTextTheme(Theme.of(context).textTheme),
      ),
      home: const HomeScreen(),
    );
  }
}
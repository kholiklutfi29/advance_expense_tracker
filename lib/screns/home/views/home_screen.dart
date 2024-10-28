import 'dart:math';

import 'package:advance_expense_tracker/screns/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:advance_expense_tracker/screns/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:advance_expense_tracker/screns/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:advance_expense_tracker/screns/add_expense/views/add_expense.dart';
import 'package:advance_expense_tracker/screns/home/blocs/get_expenses_bloc/get_expenses_bloc.dart';
import 'package:advance_expense_tracker/screns/home/views/main_screen.dart';
import 'package:advance_expense_tracker/screns/stats/stats.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetExpensesBloc, GetExpensesState>(
      builder: (context, state) {
        if (state is GetExpensesSuccess) {
          return Scaffold(
            backgroundColor: Colors.grey[50]!.withOpacity(0.95),
            bottomNavigationBar: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
                bottom: Radius.circular(30),
              ),
              child: BottomNavigationBar(
                currentIndex: index, // to light the icon
                onTap: (value) {
                  setState(() {
                    index = value;
                  });
                },
                selectedItemColor: Colors.blueAccent,
                unselectedItemColor: Colors.grey,
                backgroundColor: Colors.white,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                elevation: 3,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(CupertinoIcons.home),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      CupertinoIcons.graph_square,
                    ),
                    label: "Stats",
                  ),
                ],
              ),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                // navigate to add expense
                var newExpense = await Navigator.push(
                  context,
                  MaterialPageRoute<Expense>(
                    builder: (context) => MultiBlocProvider(
                      providers: [
                        BlocProvider(
                          create: (context) =>
                              CreateCategoryBloc(FirebaseExpenseRepo()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              GetCategoriesBloc(FirebaseExpenseRepo())
                                ..add(GetCategories()),
                        ),
                        BlocProvider(
                          create: (context) =>
                              CreateExpenseBloc(FirebaseExpenseRepo()),
                        ),
                      ],
                      child: const AddExpense(),
                    ),
                  ),
                );

                if(newExpense != null) {
                  setState(() {
                    setState(() {
                      state.expenses.insert(0, newExpense);
                    });
                  });
                }
              },
              shape: const CircleBorder(),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.tertiary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.primary,
                  ], transform: const GradientRotation(pi / 4) // 45 derajat
                      ),
                ),
                child: const Icon(
                  CupertinoIcons.add,
                ),
              ),
            ),
            body: index == 0 ? MainScreen(state.expenses) : const StatsScreen(),
          );
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}

import 'package:expense_repository/expense_repository.dart';

abstract class ExpenseRepository {

// create a category
Future<void> createCategory(Category category);

// get category
Future<List<Category>> getCategory();

// create expense 
Future<void> createExpense(Expense expense);

// get all expense
  Future<List<Expense>> getExpense();

}
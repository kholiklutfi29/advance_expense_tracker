import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_repository/expense_repository.dart';

class FirebaseExpenseRepo implements ExpenseRepository {
  final categoryCollection = FirebaseFirestore.instance.collection('categories');
  final expenseCollection = FirebaseFirestore.instance.collection('expenses');


  @override
  Future<void> createCategory(Category category) async {

    try {
      // to store to firebase
      await categoryCollection
      .doc(category.categoryId)
      .set(
        category.toEntity().toDocument(),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }

  }

  @override
  Future<List<Category>> getCategory() async {

    try {
      // get all the category from firebase
      return await categoryCollection
      .get()
      .then((value) => value.docs.map((e) => Category.fromEntity(CategoryEntity.fromDocument(e.data(),),),)
      .toList());

    } catch (e) {
      log(e.toString());
      rethrow;
    }

  }

  @override
  Future<void> createExpense(Expense expense) async {

    try {
      // to store to firebase
      await expenseCollection
      .doc(expense.expenseId)
      .set(
        expense.toEntity().toDocument(),
      );
    } catch (e) {
      log(e.toString());
      rethrow;
    }

  }

  @override
  Future<List<Expense>> getExpense() async {

    try {
      // get all the category from firebase
      return await expenseCollection
      .get()
      .then((value) => value.docs.map((e) => Expense.fromEntity(ExpenseEntity.fromDocument(e.data(),),),)
      .toList());

    } catch (e) {
      log(e.toString());
      rethrow;
    }

  }

}
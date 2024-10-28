import 'package:advance_expense_tracker/screns/add_expense/blocs/create_expense_bloc/create_expense_bloc.dart';
import 'package:advance_expense_tracker/screns/add_expense/blocs/get_categories_bloc/get_categories_bloc.dart';
import 'package:advance_expense_tracker/screns/add_expense/views/category_creation.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class AddExpense extends StatefulWidget {
  const AddExpense({super.key});

  @override
  State<AddExpense> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpense> {
  final _amountController = TextEditingController();
  final _categoryController = TextEditingController();
  final _dateController = TextEditingController();
  // DateTime _selectedDate = DateTime.now();
  late Expense expense;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    expense = Expense.empty;
    expense.expenseId = const Uuid().v1();
  }

  void _onShowDatePicker() async {
    DateTime? newDate = await showDatePicker(
      context: context,
      initialDate: expense.date,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(
        const Duration(days: 365),
      ),
    );

    if (newDate != null) {
      setState(() {
        _dateController.text = DateFormat('dd-MM-yyyy').format(newDate);
        // _selectedDate = newDate;
        expense.date = newDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CreateExpenseBloc, CreateExpenseState>(
      listener: (context, state) {
        if (state is CreateExpenseSuccess) {
          Navigator.pop(context, expense);
        } else if (state is CreateExpenseLoading) {
          setState(() {
            isLoading = true;
          });
        }
      },
      child: GestureDetector(
        // when tap on entire screen will unfocus tap of latest widget
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
          ),
          body: BlocBuilder<GetCategoriesBloc, GetCategoriesState>(
            builder: (context, state) {
              if (state is GetCategoriesSuccess) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Add Expense',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextFormField(
                            controller: _amountController,
                            keyboardType: TextInputType.number,
                            textAlignVertical: TextAlignVertical.center,
                            decoration: InputDecoration(
                              hintText: 'Enter Amount',
                              prefixIcon: const Icon(
                                FontAwesomeIcons.dollarSign,
                                color: Colors.grey,
                                size: 16,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        TextFormField(
                          controller: _categoryController,
                          readOnly: true,
                          onTap: () {},
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            hintText: 'Category',
                            prefixIcon: expense.category == Category.empty
                                ? const Icon(
                                    FontAwesomeIcons.list,
                                    color: Colors.grey,
                                    size: 16,
                                  )
                                : Image.asset(
                                    'assets/${expense.category.icon}.png',
                                    scale: 14,
                                  ),
                            suffixIcon: IconButton(
                              onPressed: () async {
                                var newCategory = await onShowDialog(context);
                                print(newCategory);
                                setState(() {
                                  state.categories.insert(0, newCategory);
                                });
                              },
                              icon: const Icon(
                                FontAwesomeIcons.plus,
                                color: Colors.grey,
                                size: 16,
                              ),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(12)),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        Container(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.vertical(
                              bottom: Radius.circular(
                                12,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListView.builder(
                              itemCount: state.categories.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: ListTile(
                                    onTap: () {
                                      setState(() {
                                        expense.category =
                                            state.categories[index];
                                        _categoryController.text =
                                            expense.category.name;
                                      });
                                    },
                                    leading: Image.asset(
                                      'assets/${state.categories[index].icon}.png',
                                      scale: 2,
                                    ),
                                    title: Text(state.categories[index].name),
                                    tileColor:
                                        Color(state.categories[index].color),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        TextFormField(
                          controller: _dateController,
                          textAlignVertical: TextAlignVertical.center,
                          readOnly: true, // to disable user to type anything
                          onTap: _onShowDatePicker,
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              FontAwesomeIcons.clock,
                              color: Colors.grey,
                              size: 16,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: kToolbarHeight,
                          child: isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : TextButton(
                                  onPressed: () {
                                    setState(() {
                                      expense.amount = int.parse(
                                        _amountController.text,
                                      );
                                    });

                                    context
                                        .read<CreateExpenseBloc>()
                                        .add(CreateExpense(expense));
                                  },
                                  style: TextButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    backgroundColor: Colors.black,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text(
                                    'Save',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

  // void _onShowDialog() {
  //   const Map<String, List<String>> myCategoryIcon = {
  //     'entertainment': ['entertainment', 'Entertainment'],
  //     'food': ['food', 'Meals'],
  //     'home': ['home', 'Housing'],
  //     'pet': ['pet', 'Pet Care'],
  //     'shopping': ['shopping', 'Shopping'],
  //     'tech': ['tech', 'Electronics'],
  //     'travel': ['travel', 'Travel'],
  //   };

  //   final List<String> keys = myCategoryIcon.keys.toList();

  //   showDialog(
  //     context: context,
  //     builder: (ctx) {
  //       String selectedIcon = '';
  //       Color categoryColor = Colors.white;
  //       final categoryNameController = TextEditingController();
  //       final categoryIconController = TextEditingController();
  //       final categoryColorController = TextEditingController();

  //       bool isExpanded = false;
  //       bool isLoading = false;

  //       return BlocProvider.value(
  //         value: context.read<CreateCategoryBloc>(),
  //         child: BlocListener<CreateCategoryBloc, CreateCategoryState>(
  //           listener: (context, state) {
  //             if (state is CreateCategorySuccess) {
  //               Navigator.of(ctx).pop();
  //             } else if (state is CreateCategoryLoading) {
  //               setState(() {
  //                 isLoading = true;
  //               });
  //             }
  //           },
  //           child: StatefulBuilder(
  //             // alert dialog cant re-render without statefulbuilder
  //             builder: (ctx, setState) => AlertDialog(
  //               title: const Center(
  //                 child: Text(
  //                   'Create a category',
  //                 ),
  //               ),
  //               backgroundColor: const Color.fromARGB(255, 201, 245, 227),
  //               content: SizedBox(
  //                 width: MediaQuery.of(context).size.width,
  //                 child: Column(
  //                   mainAxisSize: MainAxisSize.min,
  //                   children: [
  //                     TextFormField(
  //                       controller: categoryNameController,
  //                       textAlignVertical: TextAlignVertical.center,
  //                       decoration: InputDecoration(
  //                         hintText: 'Name',
  //                         isDense: true,
  //                         filled: true,
  //                         fillColor: Colors.white,
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                           borderSide: BorderSide.none,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     TextFormField(
  //                       controller: categoryIconController,
  //                       textAlignVertical: TextAlignVertical.center,
  //                       onTap: () {
  //                         setState(() {
  //                           isExpanded = !isExpanded;
  //                         });
  //                       },
  //                       readOnly: true, // to disable user to type anything
  //                       decoration: InputDecoration(
  //                         suffixIcon: Icon(
  //                           isExpanded
  //                               ? CupertinoIcons.chevron_up
  //                               : CupertinoIcons.chevron_down,
  //                         ),
  //                         hintText: 'Icon',
  //                         isDense: true,
  //                         filled: true,
  //                         fillColor: Colors.white,
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                           borderSide: BorderSide.none,
  //                         ),
  //                       ),
  //                     ),
  //                     if (isExpanded) ...[
  //                       const SizedBox(
  //                         height: 8,
  //                       ),
  //                       Container(
  //                         width: MediaQuery.of(context).size.width,
  //                         height: 200,
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.circular(12),
  //                         ),
  //                         child: Padding(
  //                           padding: const EdgeInsets.all(8.0),
  //                           child: GridView.builder(
  //                             gridDelegate:
  //                                 const SliverGridDelegateWithFixedCrossAxisCount(
  //                               crossAxisCount: 3,
  //                               crossAxisSpacing: 5,
  //                               mainAxisSpacing: 5,
  //                             ),
  //                             itemCount: myCategoryIcon.length,
  //                             itemBuilder: (context, index) => CategoryItem(
  //                               categoryItem: myCategoryIcon[keys[index]]!,
  //                               iconSelected: selectedIcon,
  //                               onSelected: (category) {
  //                                 setState(() {
  //                                   selectedIcon =
  //                                       category; // Update kategori yang dipilih
  //                                 });
  //                               },
  //                             ),
  //                           ),
  //                         ),
  //                       )
  //                     ] else
  //                       Container(),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     TextFormField(
  //                       controller: categoryColorController,
  //                       onTap: () {
  //                         showDialog(
  //                           context: context,
  //                           builder: (ctx2) {
  //                             return AlertDialog(
  //                               content: Column(
  //                                 mainAxisSize: MainAxisSize.min,
  //                                 children: [
  //                                   ColorPicker(
  //                                     pickerColor: categoryColor,
  //                                     onColorChanged: (value) {
  //                                       setState(
  //                                         () {
  //                                           categoryColor = value;
  //                                         },
  //                                       );
  //                                     },
  //                                   ),
  //                                   SizedBox(
  //                                     width: double.infinity,
  //                                     height: 50,
  //                                     child: TextButton(
  //                                       onPressed: () {
  //                                         print(categoryColor);
  //                                         Navigator.pop(ctx2);
  //                                       },
  //                                       style: TextButton.styleFrom(
  //                                         shape: RoundedRectangleBorder(
  //                                           borderRadius:
  //                                               BorderRadius.circular(12),
  //                                         ),
  //                                         backgroundColor: Colors.black,
  //                                         foregroundColor: Colors.white,
  //                                       ),
  //                                       child: const Text(
  //                                         'Save',
  //                                         style: TextStyle(
  //                                           fontSize: 22,
  //                                           fontWeight: FontWeight.w500,
  //                                         ),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                         );
  //                       },
  //                       textAlignVertical: TextAlignVertical.center,
  //                       readOnly: true, // to disable user to type anything
  //                       decoration: InputDecoration(
  //                         hintText: 'Color',
  //                         isDense: true,
  //                         filled: true,
  //                         fillColor: categoryColor,
  //                         border: OutlineInputBorder(
  //                           borderRadius: BorderRadius.circular(12),
  //                           borderSide: BorderSide.none,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     SizedBox(
  //                       width: double.infinity,
  //                       height: kToolbarHeight,
  //                       child: isLoading == true
  //                           ? const Center(
  //                               child: CircularProgressIndicator(),
  //                             )
  //                           : TextButton(
  //                               onPressed: () {
  //                                 // create a category and pop
  //                                 Category category = Category.empty;
  //                                 category.categoryId = const Uuid().v1();
  //                                 category.name = categoryNameController.text;
  //                                 category.icon = selectedIcon;
  //                                 category.color = categoryColor.toString();

  //                                 // add with bloc
  //                                 context
  //                                     .read<CreateCategoryBloc>()
  //                                     .add(CreateCategory(category));

  //                                 // Navigator.pop(context);
  //                               },
  //                               style: TextButton.styleFrom(
  //                                 shape: RoundedRectangleBorder(
  //                                   borderRadius: BorderRadius.circular(12),
  //                                 ),
  //                                 backgroundColor: Colors.black,
  //                                 foregroundColor: Colors.white,
  //                               ),
  //                               child: const Text(
  //                                 'Save',
  //                                 style: TextStyle(
  //                                   fontSize: 22,
  //                                   fontWeight: FontWeight.w500,
  //                                 ),
  //                               ),
  //                             ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

import 'package:advance_expense_tracker/screns/add_expense/blocs/create_category_bloc/create_category_bloc.dart';
import 'package:advance_expense_tracker/screns/add_expense/widgets/category_item.dart';
import 'package:expense_repository/expense_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:uuid/uuid.dart';

Future onShowDialog(BuildContext context) {
  const Map<String, List<String>> myCategoryIcon = {
    'entertainment': ['entertainment', 'Entertainment'],
    'food': ['food', 'Meals'],
    'home': ['home', 'Housing'],
    'pet': ['pet', 'Pet Care'],
    'shopping': ['shopping', 'Shopping'],
    'tech': ['tech', 'Electronics'],
    'travel': ['travel', 'Travel'],
  };

  final List<String> keys = myCategoryIcon.keys.toList();

  return showDialog(
    context: context,
    builder: (ctx) {
      String selectedIcon = '';
      Color categoryColor = Colors.white;
      final categoryNameController = TextEditingController();
      final categoryIconController = TextEditingController();
      final categoryColorController = TextEditingController();
      Category category = Category.empty;

      bool isExpanded = false;
      bool isLoading = false;

      return BlocProvider.value(
        value: context.read<CreateCategoryBloc>(),
        child: StatefulBuilder(
          builder: (ctx, setState) =>
              BlocListener<CreateCategoryBloc, CreateCategoryState>(
            listener: (context, state) {
              if (state is CreateCategorySuccess) {
                Navigator.pop(ctx, category);
              } else if (state is CreateCategoryLoading) {
                setState(() {
                  isLoading = true;
                });
              }
            },
            child: AlertDialog(
              title: const Center(
                child: Text(
                  'Create a category',
                ),
              ),
              backgroundColor: const Color.fromARGB(255, 201, 245, 227),
              content: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: categoryNameController,
                      textAlignVertical: TextAlignVertical.center,
                      decoration: InputDecoration(
                        hintText: 'Name',
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: categoryIconController,
                      textAlignVertical: TextAlignVertical.center,
                      onTap: () {
                        setState(() {
                          isExpanded = !isExpanded;
                        });
                      },
                      readOnly: true, // to disable user to type anything
                      decoration: InputDecoration(
                        suffixIcon: Icon(
                          isExpanded
                              ? CupertinoIcons.chevron_up
                              : CupertinoIcons.chevron_down,
                        ),
                        hintText: 'Icon',
                        isDense: true,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      const SizedBox(
                        height: 8,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              mainAxisSpacing: 5,
                            ),
                            itemCount: myCategoryIcon.length,
                            itemBuilder: (context, index) => CategoryItem(
                              categoryItem: myCategoryIcon[keys[index]]!,
                              iconSelected: selectedIcon,
                              onSelected: (category) {
                                setState(() {
                                  selectedIcon =
                                      category; // Update kategori yang dipilih
                                });
                              },
                            ),
                          ),
                        ),
                      )
                    ] else
                      Container(),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: categoryColorController,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx2) {
                            return AlertDialog(
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ColorPicker(
                                    pickerColor: categoryColor,
                                    onColorChanged: (value) {
                                      setState(
                                        () {
                                          categoryColor = value;
                                        },
                                      );
                                    },
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: TextButton(
                                      onPressed: () {
                                        print(categoryColor);
                                        Navigator.pop(ctx2);
                                      },
                                      style: TextButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(12),
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
                            );
                          },
                        );
                      },
                      textAlignVertical: TextAlignVertical.center,
                      readOnly: true, // to disable user to type anything
                      decoration: InputDecoration(
                        hintText: 'Color',
                        isDense: true,
                        filled: true,
                        fillColor: categoryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: kToolbarHeight,
                      child: isLoading == true
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : TextButton(
                              onPressed: () {
                                // create a category and pop
                                setState(() {
                                  category.categoryId = const Uuid().v1();
                                  category.name = categoryNameController.text;
                                  category.icon = selectedIcon;
                                  category.color = categoryColor.value;
                                });

                                // add with bloc
                                context
                                    .read<CreateCategoryBloc>()
                                    .add(CreateCategory(category));

                                // Navigator.pop(context);
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
            ),
          ),
        ),
      );
    },
  );
}

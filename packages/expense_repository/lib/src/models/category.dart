import '../entities/entities.dart';

class Category {

  String categoryId;
  String name;
  int totalExpense;
  String  icon;
  int color;

  Category({
    required this.categoryId,
    required this.name,
    required this.totalExpense,
    required this.color,
    required this.icon,
  });

  // to initialize
  static final empty = Category(
    categoryId: '',
    name: '',
    totalExpense: 0,
    color: 0,
    icon: '',
  );


  CategoryEntity toEntity(){
    return CategoryEntity(
      categoryId: categoryId,
      name: name,
      totalExpense : totalExpense,
      icon : icon,
      color : color,
    );
  }

  static Category fromEntity(CategoryEntity entity){
    return Category(
      categoryId: entity.categoryId,
      name: entity.name,
      totalExpense: entity.totalExpense,
      icon: entity.icon,
      color: entity.color
    );
  }
}
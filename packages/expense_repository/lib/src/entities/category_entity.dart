class CategoryEntity {

  String categoryId;
  String name;
  int totalExpense;
  String  icon;
  int color;

  CategoryEntity({
    required this.categoryId,
    required this.name,
    required this.totalExpense,
    required this.color,
    required this.icon,
  });

  Map<String, Object?> toDocument(){
    return {
      'categoryId': categoryId,
      'name': name,
      'totalExpense': totalExpense,
      'color': color,
      'icon': icon,
    };
  }

  static CategoryEntity fromDocument(Map<String, dynamic> doc){
    return CategoryEntity(
      categoryId: doc['categoryId'],
      name: doc['name'],
      totalExpense: doc['totalExpense'],
      color: doc['color'],
      icon: doc['icon'],
    );
  }
}
class Category {
  int? id;
  String? categoryName;

  Category({
    this.id,
    this.categoryName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'categoryName': categoryName,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      categoryName: map['categoryName'],
    );
  }
}
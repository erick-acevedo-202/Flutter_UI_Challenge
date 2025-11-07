class CategoryModel {
  final int category_id;
  final String category_name;

  CategoryModel({
    required this.category_id,
    required this.category_name,
  });

  Map<String, dynamic> toMap() {
    return {
      'category_id': category_id,
      'category_name': category_name,
    };
  }

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      category_id: map['category_id'],
      category_name: map['category_name'],
    );
  }
}

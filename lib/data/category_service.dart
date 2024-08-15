import '../models/category.dart';
import 'db_helper.dart';

class CategoryService{
  static List<Category> categories = [];

  static CategoryService _singleton = CategoryService._internal();

  factory CategoryService(){
    return _singleton;
  }

  CategoryService._internal();

  final DbHelper _dbHelper = DbHelper();

  Future<List<Category>> getAll() async {
    List<Map<String, dynamic>> data = await _dbHelper.getCategories();
    categories = data.map((map) => Category.fromMap(map)).toList();
    return categories;
  }
}
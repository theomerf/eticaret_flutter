import '../models/product.dart';
import 'db_helper.dart';

class ProductService {
  static List<Product> products = [];

  static ProductService _singleton = ProductService._internal();

  factory ProductService(){
    return _singleton;
  }

  ProductService._internal();

  static final DbHelper _dbHelper = DbHelper();

  static Future<List<Product>> getAll() async{
    List<Map<String, dynamic>> data = await _dbHelper.getProducts();
    products = data.map((map) => Product.fromMap(map)).toList();
    return products;
  }

  static Future<List<Product>> getByCategory(int categoryId) async{
    List<Map<String, dynamic>> data = await _dbHelper.getProductsByCategory(categoryId);
    products = data.map((map) => Product.fromMap(map)).toList();
    return products;
  }

  static Future<List<Product>> searchProducts(String productName) async{
    List<Map<String, dynamic>> data = await _dbHelper.searchProductsByName(productName);
    products = data.map((map) => Product.fromMap(map)).toList();
    return products;
  }
}

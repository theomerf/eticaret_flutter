import '../models/cart_item.dart';

import 'db_helper.dart';

class CartService {
  static List<CartItem> cartItems = [];

  static CartService _singleton = CartService._internal();

  factory CartService(){
    return _singleton;
  }

  CartService._internal();

  static final DbHelper _dbHelper = DbHelper();

  static Future<void> addToCart(String userId, CartItem item) async{
    await _dbHelper.addOrUpdateCartItem(userId, item);
  }

  static Future<void> removeFromCart(String userId, CartItem item) async{
    await _dbHelper.removeFromCart(userId, item);
  }

  static Future<void> emptyCart(String userId) async{
    await _dbHelper.emptyCart(userId);
  }

  static Future<List<CartItem>> getCart(String userId) async {
    Map<String, dynamic> data = await _dbHelper.getCart(userId);
    return data.entries.map((entry) => CartItem.fromMap(entry.value)).toList();
  }
}
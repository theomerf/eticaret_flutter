import 'dart:async';
import 'package:alisverisproje/data/cart_service.dart';
import '../models/cart_item.dart';

class CartBloc {
  final cartStreamController = StreamController<List<CartItem>>.broadcast();

  Stream<List<CartItem>> get getStream => cartStreamController.stream;

  Future<void> addToCart(String userId, CartItem item) async {
    await CartService.addToCart(userId, item);
    await _refreshCart(userId);
  }

  Future<void> removeFromCart(String userId, CartItem item) async {
    await CartService.removeFromCart(userId, item);
    await _refreshCart(userId);
  }

  Future<void> getCart(String userId) async {
    await _refreshCart(userId);
  }

  Future<void> emptyCart(String userId) async {
    await CartService.emptyCart(userId);
    await _refreshCart(userId);
  }

  Future<void> _refreshCart(String userId) async {
    List<CartItem> cartItems = await CartService.getCart(userId);
    cartStreamController.sink.add(cartItems);
  }

  void dispose() {
    cartStreamController.close();
  }
}

final cartBloc = CartBloc();

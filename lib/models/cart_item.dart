import 'product.dart';

class CartItem {
  int id;
  Product product;
  int quantity;

  CartItem({
    required this.id,
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'product': product.toMap(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      product: Product.fromMap(map['product'] as Map<String, dynamic>),
      quantity: map['quantity'],
    );
  }
}

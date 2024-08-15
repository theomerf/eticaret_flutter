import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../models/cart_item.dart';
import '../models/account.dart';
import '../widgets/order_widget.dart';

class OrderScreen extends StatelessWidget {
  final double totalPrice;

  OrderScreen(this.totalPrice);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Siparişi Tamamla"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: StreamBuilder<Account?>(
        stream: AccountBloc().getStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else if (snapshot.hasData && snapshot.data != null) {
            final userId = snapshot.data!.id.toString();
            cartBloc.getCart(userId);
            return StreamBuilder<List<CartItem>>(
              stream: cartBloc.getStream,
              builder: (context, cartSnapshot) {
                if (cartSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (cartSnapshot.hasError) {
                  return Center(child: Text("Hata: ${cartSnapshot.error}"));
                } else if (cartSnapshot.hasData && cartSnapshot.data != null) {
                  final cartItems = cartSnapshot.data!;
                  return OrderWidget(cartItems, userId);
                }
                else{
                  return Center(child: Text("Hata: ${cartSnapshot.error}"));
                }
              },
            );
          } else {
            return Center(child: Text("Kullanıcı bilgileri yüklenemedi."));
          }
        },
      ),
    );
  }
}

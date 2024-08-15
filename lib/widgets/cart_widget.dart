import 'package:flutter/material.dart';

import '../blocs/cart_bloc.dart';
import '../models/cart_item.dart';
import 'cart_price_widget.dart';

class CartWidget extends StatelessWidget{
  final BuildContext context;
  final String userId;

  CartWidget(this.context,this.userId);

  @override
  Widget build(BuildContext context) {
    return buildWidget(context, userId);
  }

  Widget buildWidget(BuildContext context, String userId){
    cartBloc.getCart(userId);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sepet",
          style: TextStyle(color: Colors.white, fontSize: 20.0),
        ),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: StreamBuilder<List<CartItem>>(
        stream: cartBloc.getStream,
        builder: (context, snapshot) {
          if (snapshot.hasData && snapshot.data != null) {
            return buildCart(snapshot.data!, userId);
          } else if (snapshot.hasError) {
            return Center(child: Text("Hata: ${snapshot.error}"));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildCart(List<CartItem> cartItems, String userId) {
    double totalPrice = cartItems.fold(
      0,
          (sum, item) => sum + (item.product.unitPrice! * item.quantity),
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final cardMargin = EdgeInsets.all(screenWidth * 0.03);
        final cardPadding = EdgeInsets.all(screenWidth * 0.03);
        final itemHeight = screenWidth * 0.2;
        final itemFontSize = screenWidth * 0.04;
        final totalPriceFontSize = screenWidth * 0.045;
        final iconSize = screenWidth * 0.07;

        return Container(
          margin: cardMargin,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(screenWidth * 0.05),
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              buildCartItems(cartItems, screenWidth, cardPadding, itemHeight, itemFontSize, totalPriceFontSize, iconSize),
              CartPriceWidget(totalPrice: totalPrice),
              SizedBox(height: screenWidth * 0.03),
            ],
          ),
        );
      },
    );
  }

  Widget buildCartItems(cartItems, screenWidth, cardPadding, itemHeight, itemFontSize, totalPriceFontSize, iconSize) {
    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (BuildContext context, index) {
          final cartItem = cartItems[index];
          return Container(
            height: itemHeight,
            decoration: BoxDecoration(
              color: index % 2 == 0 ? Colors.lightBlueAccent.withOpacity(0.1) : Colors.white,
              borderRadius: BorderRadius.vertical(
                top: index == 0 ? Radius.circular(screenWidth * 0.05) : Radius.zero,
              ),
            ),
            padding: cardPadding,
            child: Row(
              children: [
                Container(
                  width: itemHeight * 0.9,
                  height: itemHeight * 0.75,
                  padding: EdgeInsets.all(screenWidth * 0.01),
                  child: Image.network(
                    cartItem.product.imgUrl ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${cartItem.product.name} (${cartItem.quantity})",
                        style: TextStyle(fontSize: itemFontSize),
                      ),
                      SizedBox(height: screenWidth * 0.02),
                      Text(
                        "${(cartItem.product.unitPrice! * cartItem.quantity!).toStringAsFixed(2)} TL",
                        style: TextStyle(fontSize: itemFontSize),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.remove_shopping_cart, size: iconSize),
                  onPressed: () {
                    cartBloc.removeFromCart(userId, cartItem);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

}
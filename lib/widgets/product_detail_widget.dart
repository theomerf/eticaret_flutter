import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../models/account.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class ProductDetailWidget extends StatefulWidget {
  final Product product;

  ProductDetailWidget({required this.product});

  @override
  _ProductDetailWidgetState createState() => _ProductDetailWidgetState();
}

class _ProductDetailWidgetState extends State<ProductDetailWidget> {
  int quantity = 1;

  void incrementQuantity() {
    setState(() {
      quantity++;
    });
  }

  void decrementQuantity() {
    if (quantity > 1) {
      setState(() {
        quantity--;
      });
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Başarılı'),
          content: Text('Ürün başarıyla sepete eklendi.'),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;
    double totalPrice = widget.product.unitPrice! * quantity;

    return StreamBuilder<Account?>(
      stream: AccountBloc().getStream,
      builder: (context, snapshot) {
        String? userId = snapshot.data?.id.toString();

        return buildBody(screenHeight,screenWidth, totalPrice, userId);
      },
    );
  }

  Widget buildBody(screenHeight,screenWidth, totalPrice, userId) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: screenHeight * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
              image: DecorationImage(
                image: NetworkImage(widget.product.imgUrl ?? ""),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(screenWidth * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    widget.product.name ?? "",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: screenWidth * 0.052,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: screenHeight * 0.01),
                Divider(color: Colors.black54),
                SizedBox(height: screenHeight * 0.02),
                Container(
                  padding: EdgeInsets.all(10.0),
                  height: screenHeight * 0.25,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                    border: Border.all(color: Colors.black),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black,
                        blurRadius: 8.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(
                        widget.product.description ?? "",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.045,
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.remove_circle_outline),
                      onPressed: decrementQuantity,
                      iconSize: screenWidth * 0.08,
                    ),
                    Text(
                      '$quantity',
                      style: TextStyle(
                        fontSize: screenWidth * 0.06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.add_circle_outline),
                      onPressed: incrementQuantity,
                      iconSize: screenWidth * 0.08,
                    ),
                  ],
                ),
                SizedBox(height: screenHeight * 0.01),
                Center(
                  child: Text(
                    'Toplam Fiyat: ${totalPrice.toStringAsFixed(2)}₺',
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
              ],
            ),
          ),
          buildButton(screenWidth, screenHeight, userId)
        ],
      ),
    );
  }

  Widget buildButton(screenWidth, screenHeight, userId){
    return ElevatedButton(
      onPressed: () {
        if(userId != null){
          CartBloc().addToCart(
            userId!,
            CartItem(
              id: widget.product.id!,
              product: widget.product,
              quantity: quantity,
            ),
          );
          _showSuccessDialog();
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sepete eklemek için lütfen giriş yapın.')),
          );
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20.0),
            bottomRight: Radius.circular(20.0),
          ),
        ),
        minimumSize: Size(double.infinity, screenHeight * 0.07),
        backgroundColor: Colors.lightBlueAccent,
      ),
      child: Text(
        'Sepete Ekle',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          color: Colors.white,
        ),
      ),
    );
  }
}

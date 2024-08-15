import 'package:flutter/material.dart';

import '../screens/order_screen.dart';

class CartPriceWidget extends StatelessWidget {
  final double totalPrice;

  CartPriceWidget({required this.totalPrice});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final padding = screenWidth * 0.03;
        final containerHeight = 0.29 * screenWidth;
        final borderRadius = 10.0;
        final fontSizeLarge = screenWidth * 0.05;
        final fontSizeSmall = screenWidth * 0.04;

        return Container(
          height: containerHeight,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              top: BorderSide(color: Colors.black.withOpacity(0.2), width: 1.0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8.0,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: EdgeInsets.all(padding),
          child: Row(
            children: [
              buildBody(padding, borderRadius, fontSizeLarge, fontSizeSmall),
              SizedBox(width: padding),
              buildButtton(borderRadius, fontSizeSmall, context)
            ],
          ),
        );
      },
    );
  }

  Widget buildBody(padding, borderRadius, fontSizeLarge, fontSizeSmall){
    return Expanded(
      flex: 2,
      child: Container(
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Toplam Ürün Tutarı:",
              style: TextStyle(
                fontSize: fontSizeLarge,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: padding * 0.5),
            Text(
              "${totalPrice.toStringAsFixed(2)} TL",
              style: TextStyle(
                fontSize: fontSizeSmall,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButtton(borderRadius, fontSizeSmall, context){
    return Expanded(
      flex: 1,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlueAccent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Siparişi",
              style: TextStyle(fontSize: fontSizeSmall, color: Colors.white),
            ),
            Text(
              "Tamamla",
              style: TextStyle(fontSize: fontSizeSmall, color: Colors.white),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OrderScreen(totalPrice)),
          );
        },
      ),
    );
  }
}

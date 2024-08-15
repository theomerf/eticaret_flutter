import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_detail_widget.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name!),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: buildBody(screenHeight, screenWidth),
    );
  }

  Widget buildBody(double screenHeight, double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: screenHeight * 0.85,
            margin: EdgeInsets.all(screenWidth * 0.05),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.black.withOpacity(0.2)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ProductDetailWidget(product: product),
          ),
        ],
      ),
    );
  }

}

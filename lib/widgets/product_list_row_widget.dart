import 'package:flutter/material.dart';
import '../models/product.dart';
import '../screens/product_detail_screen.dart';

class ProductListRowWidget extends StatelessWidget {
  final Product product;

  ProductListRowWidget(this.product);

  @override
  Widget build(BuildContext context) {
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double containerHeight = constraints.maxWidth > 200 ? 150.0 : 120.0;

        return Card(
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: containerHeight,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.0)),
                  image: DecorationImage(
                    image: NetworkImage(product.imgUrl ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        product.name ?? "",
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: constraints.maxWidth > 200 ? 18.0 : 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Center(
                      child: Text(
                        "${product.unitPrice?.toStringAsFixed(2) ?? "0.0"} TL",
                        style: TextStyle(
                          fontSize: constraints.maxWidth > 200 ? 16.0 : 14.0,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ProductDetailScreen(product: product)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[300],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(
                        vertical: constraints.maxWidth > 200 ? 12.0 : 10.0),
                  ),
                  child: Text(
                    "İncele",
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: constraints.maxWidth > 200 ? 16.0 : 14.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

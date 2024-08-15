import 'package:flutter/material.dart';
import '../blocs/product_bloc.dart';
import '../models/product.dart';
import '../widgets/product_list_row_widget.dart';

class ProductListWidget extends StatelessWidget {
  final int categoryId;

  ProductListWidget({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BuildProductGrid();
  }

  Widget BuildProductGrid() {
    return StreamBuilder<List<Product>>(
      stream: productBloc.getStream,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          return buildProductListItems(snapshot, context);
        } else if (snapshot.hasError) {
          return Center(child: Text("Hata: ${snapshot.error}"));
        } else {
          return Center(child: Text("Ürün bulunamadı"));
        }
      },
    );
  }

  Widget buildProductListItems(AsyncSnapshot<List<Product>> snapshot, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;

          return GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 12.0,
              mainAxisSpacing: 12.0,
              childAspectRatio: 0.68,
            ),
            itemCount: snapshot.data!.length,
            itemBuilder: (BuildContext context, index) {
              final product = snapshot.data![index];
              return ProductListRowWidget(product);
            },
          );
        },
      ),
    );
  }
}

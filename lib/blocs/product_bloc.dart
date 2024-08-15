  import 'dart:async';
  import 'package:alisverisproje/data/product_service.dart';
  import '../models/product.dart';

  class ProductBloc {
    final productStreamController = StreamController<List<Product>>.broadcast();

    Stream<List<Product>> get getStream => productStreamController.stream;

    Future<void> getAll() async{
      List<Product> products = await ProductService.getAll();
      productStreamController.sink.add(products);
    }

    Future<void> getByCategory(int categoryId) async{
      List<Product> products = await ProductService.getByCategory(categoryId);
      productStreamController.sink.add(products);
    }

    Future<void> searchProducts(String productName) async{
      List<Product> products = await ProductService.searchProducts(productName);
      productStreamController.sink.add(products);
    }

    void dispose(){
      productStreamController.close();
    }

  }

  final productBloc = ProductBloc();

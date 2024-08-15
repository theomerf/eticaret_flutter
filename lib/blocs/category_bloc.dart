import 'dart:async';
import 'package:alisverisproje/data/category_service.dart';
import '../models/category.dart';

class CategoryBloc{
  final categoryStreamController = StreamController<List<Category>>.broadcast();

  Stream<List<Category>> get getStream => categoryStreamController.stream;

  Future<void> getAll() async {
    List<Category> categories = await CategoryService().getAll();
    categoryStreamController.sink.add(categories);
  }

  void dispose() {
    categoryStreamController.close();
  }
}

final categoryBloc = CategoryBloc();
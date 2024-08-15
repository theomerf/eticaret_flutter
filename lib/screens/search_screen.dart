import 'package:flutter/material.dart';
import '../blocs/product_bloc.dart';
import '../widgets/product_list_widget.dart';

class SearchScreen extends StatefulWidget {
  final Function(int) onSearchExit;

  SearchScreen({required this.onSearchExit});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Ürün ismini girin...',
            hintStyle: TextStyle(color: Colors.grey),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
            if (value.isNotEmpty) {
              productBloc.searchProducts(value);
            }
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            widget.onSearchExit(0);
          },
        ),
      ),
      body: _searchQuery.isEmpty
          ? Center(child: Text("Arama sonuçları burada görünecek."))
          : ProductListWidget(categoryId: 0), // Arama sonuçlarını gösterecek widget
    );
  }
}

import 'package:flutter/material.dart';
import 'package:alisverisproje/widgets/category_buttons_widget.dart';
import 'package:alisverisproje/widgets/product_list_widget.dart';
import 'package:alisverisproje/blocs/category_bloc.dart';
import 'package:alisverisproje/blocs/product_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MainScreen extends StatefulWidget {
  final Function onSearchTapped;

  MainScreen({required this.onSearchTapped});

  @override
  State<StatefulWidget> createState() {
    return MainScreenState();
  }
}

class MainScreenState extends State<MainScreen> {
  int selectedCategoryId = 0;

  @override
  void initState() {
    super.initState();
    categoryBloc.getAll();
    productBloc.getAll();
  }

  var db = FirebaseFirestore.instance;

  void onCategorySelected(int categoryId) {
    setState(() {
      selectedCategoryId = categoryId;
      if (categoryId == 0) {
        productBloc.getAll();
      } else {
        productBloc.getByCategory(categoryId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: GestureDetector(
          onTap: () {
            widget.onSearchTapped(); // Modify this line
          },
          child: Container(
            height: 40.0,
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Colors.black, width: 1.0),
            ),
            child: Row(
              children: [
                Icon(Icons.search, color: Colors.grey),
                SizedBox(width: 8.0),
                Text(
                  "Ürün ara...",
                  style: TextStyle(color: Colors.grey, fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.chat),
            onPressed: (){},
          ),
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: (){},
          ),
        ],
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Column(
      children: [
        Container(
          height: 65.0,
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20.0)),
            border: Border.all(color: Colors.black, width: 1.0),
          ),
          child: CategoryButtonsWidget(onCategorySelected: onCategorySelected),
        ),
        Expanded(
          child: ProductListWidget(categoryId: 0,),
        ),
      ],
    );
  }
}

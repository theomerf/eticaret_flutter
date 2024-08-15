import 'package:alisverisproje/models/category.dart';
import 'package:flutter/material.dart';
import '../blocs/category_bloc.dart';

class CategoryButtonsWidget extends StatelessWidget {
  final Function(int) onCategorySelected;

  CategoryButtonsWidget({required this.onCategorySelected});

  @override
  Widget build(BuildContext context) {
    return BuildCategoryButtons();
  }

  Widget BuildCategoryButtons() {
    return StreamBuilder<List<Category>>(
      stream: categoryBloc.getStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator(),);
        }
        else if (snapshot.hasData && snapshot.data != null && snapshot.data!.isNotEmpty) {
          return buildButtons(snapshot);
        } else {
          return Center(child: Text("No categories available", style: TextStyle(fontSize: 16.0)));
        }
      },
    );
  }

  Widget buildButtons(AsyncSnapshot<List<Category>> snapshot) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: snapshot.data!.map((category) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: 160,
              ),
              child: ElevatedButton(
                onPressed: () {
                  onCategorySelected(category.id!); // Pass category ID
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlueAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black.withOpacity(0.3)),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 12), // Adjust padding
                ),
                child: Text(
                  category.categoryName ?? "",
                  style: TextStyle(fontSize: 14.0, color: Colors.white), // Adjust font size and color
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

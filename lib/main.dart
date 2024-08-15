import 'package:alisverisproje/widgets/bottom_navigation_bar_widget.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'blocs/category_bloc.dart';
import 'blocs/product_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    categoryBloc.getAll();
    productBloc.getAll();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Alışveriş Uygulaması',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BottomNavigationBarWidget(),
    );
  }
}

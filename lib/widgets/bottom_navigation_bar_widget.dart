import 'package:flutter/material.dart';
import '../screens/account_screen.dart';
import '../screens/cart_screen.dart';
import '../screens/main_screen.dart';
import '../screens/search_screen.dart';

class BottomNavigationBarWidget extends StatefulWidget {
  final int initialIndex;

  BottomNavigationBarWidget({this.initialIndex = 0});

  @override
  State<BottomNavigationBarWidget> createState() => _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  late int _selectedIndex;
  bool _isSearching = false;

  static List<Widget> _pages = <Widget>[
    MainScreen(onSearchTapped: () {}), // Default onSearchTapped, will be overridden
    CartScreen(),
    AccountScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _isSearching = false; // Search mode'dan çıkılır
    });
  }

  void _onSearchTapped() {
    setState(() {
      _isSearching = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MainScreen'deki onSearchTapped fonksiyonunu burada ayarlıyoruz
    _pages[0] = MainScreen(onSearchTapped: _onSearchTapped);

    return Scaffold(
      body: _isSearching
          ? SearchScreen(onSearchExit: _onItemTapped)
          : _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Ana Sayfa',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Sepetim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_box),
            label: 'Hesabım',
          ),
        ],
        currentIndex: _selectedIndex,
        backgroundColor: Colors.lightBlueAccent,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

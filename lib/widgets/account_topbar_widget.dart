import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import 'bottom_navigation_bar_widget.dart';

class AccountTopbarWidget extends StatefulWidget {
  @override
  _AccountTopbarWidgetState createState() => _AccountTopbarWidgetState();
}

class _AccountTopbarWidgetState extends State<AccountTopbarWidget> {
  bool loggedIn = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    userBloc.getStream.listen((account) {
      if (mounted) {
        setState(() {
          loggedIn = account != null;
          username = account?.username ?? '';
        });
      }
    });
    userBloc.fetchCurrentUser();
  }

  void _logout() async {
    await userBloc.logout();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => BottomNavigationBarWidget(initialIndex: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(25.0),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: loggedIn
          ? buildNotLoggedIn()
          : buildLoggedIn()
    );
  }

  Widget buildNotLoggedIn(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Hoşgeldiniz, $username',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlueAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          ),
          onPressed: _logout,
          child: Text(
            'Çıkış Yap',
            style: TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
      ],
    );
  }

  buildLoggedIn(){
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            "Lütfen giriş yapın!",
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                'Giriş Yap',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
            SizedBox(width: 10.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text(
                'Kayıt Ol',
                style: TextStyle(color: Colors.white, fontSize: 14.0),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

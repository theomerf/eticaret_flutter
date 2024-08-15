import 'package:flutter/material.dart';
import 'package:alisverisproje/screens/register_screen.dart';
import '../blocs/account_bloc.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _errorMessage = '';

  void _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      bool loginSuccess = await userBloc.loginUser(_email, _password);
      if (loginSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BottomNavigationBarWidget(initialIndex: 2)),
        );
      } else {
        setState(() {
          _errorMessage = 'Eposta veya şifre yanlış';
        });
      }
    }
  }

  void _navigateToRegister() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Giriş Yap'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(20.0),
          child: Container(
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: buildForm()
          ),
        ),
      ),
    );
  }

  Widget buildForm(){
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_errorMessage.isNotEmpty)
            Container(
              margin: EdgeInsets.only(bottom: 10.0),
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.red, width: 1.5),
              ),
              child: Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            ),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Eposta',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Eposta gerekli';
              }
              return null;
            },
            onSaved: (value) {
              _email = value!;
            },
          ),
          SizedBox(height: 15.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Şifre',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Şifre gerekli';
              }
              return null;
            },
            onSaved: (value) {
              _password = value!;
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _login,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Giriş Yap', style: TextStyle(fontSize: 16.0)),
          ),
          SizedBox(height: 20.0),
          GestureDetector(
            onTap: _navigateToRegister,
            child: Text(
              'Hesabınız yok mu? Hemen oluşturun',
              style: TextStyle(color: Colors.lightBlueAccent, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

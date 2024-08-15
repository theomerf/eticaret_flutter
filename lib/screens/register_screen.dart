import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../widgets/bottom_navigation_bar_widget.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _imgUrl = '';

  void _register() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await userBloc.registerUser(_username, _email, _password, _imgUrl, false);
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Başarıyla kayıt oldunuz'),
          content: Text('Lütfen giriş yapın'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigationBarWidget(initialIndex: 2)),
                );
              },
              child: Text('Tamam'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kayıt Ol'),
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
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Kullanıcı Adı',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Kullanıcı adı gerekli';
              }
              return null;
            },
            onSaved: (value) {
              _username = value!;
            },
          ),
          SizedBox(height: 15.0),
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
          SizedBox(height: 15.0),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Profil Resmi URL (Opsiyonel)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.image),
            ),
            onSaved: (value) {
              _imgUrl = value!;
            },
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            onPressed: _register,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Kayıt Ol', style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }
}

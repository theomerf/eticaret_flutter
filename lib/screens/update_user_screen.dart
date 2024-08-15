import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../data/account_service.dart';
import '../widgets/bottom_navigation_bar_widget.dart';
import '../models/account.dart';

class UpdateUserScreen extends StatefulWidget {
  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  final _formKey = GlobalKey<FormState>();
  String _username = '';
  String _email = '';
  String _password = '';
  String _imgUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Mevcut kullanıcı bilgilerini yükle
    userBloc.getStream.listen((account) {
      if (mounted) {
        setState(() {
          if (account != null) {
            _username = account.username!;
            _email = account.email!;
            _imgUrl = account.imgUrl!;
          }
          isLoading = false;
        });
      }
    });
    userBloc.fetchCurrentUser();
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final currentUser = await AccountService.getCurrentUser();
      if (currentUser != null) {
        Account updatedAccount = Account(
          id: int.tryParse(currentUser.uid),
          username: _username,
          email: _email,
          imgUrl: _imgUrl,
          isAdmin: false, // Kullanıcı admin değilse
        );
        await userBloc.updateUserInfo(currentUser.uid, updatedAccount);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Bilgiler güncellendi'),
            content: Text('Kullanıcı bilgileri başarıyla güncellendi.'),
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
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: Text('Bilgilerini Güncelle')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Bilgilerini Güncelle'),
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
            child: buildForm(),
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
            initialValue: _username,
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
            initialValue: _email,
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
              labelText: 'Yeni Şifre (Opsiyonel)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.lock),
            ),
            obscureText: true,
            onSaved: (value) {
              _password = value!;
            },
          ),
          SizedBox(height: 15.0),
          TextFormField(
            initialValue: _imgUrl,
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
            onPressed: _updateUser,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              padding: EdgeInsets.all(10.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: Text('Güncelle', style: TextStyle(fontSize: 16.0)),
          ),
        ],
      ),
    );
  }
}

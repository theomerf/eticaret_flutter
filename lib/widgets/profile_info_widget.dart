import 'package:alisverisproje/screens/update_user_screen.dart';
import 'package:flutter/material.dart';
import 'package:alisverisproje/blocs/account_bloc.dart';
import '../models/account.dart';

class ProfileInfoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return buildWidget(context);
  }

  Widget buildWidget(BuildContext context) {
    return StreamBuilder<Account?>(
      stream: AccountBloc().getStream,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        else if(snapshot.hasError){
          return Center(
            child: Text("Hata"),
          );
        }
        else if(snapshot.hasData && snapshot.data != null){
          String userId = snapshot.data!.id.toString();
          String username = snapshot.data!.username ?? "";
          String email = snapshot.data!.email ?? "";
          String imgUrl = snapshot.data!.imgUrl ?? "";
          return buildBody(context, userId, username, email, imgUrl);
        }
        else{
          return Center(
            child: Text("Tanımlanamayan hata"),
          );
        }
      },
    );
  }

  Widget buildBody(BuildContext context, String userId, String username, String email, String imgUrl){
    return Container(
      height: 360,
      margin: EdgeInsets.all(15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8.0,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Text(
              "Profil Bilgisi",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: 5.0),
          Divider(thickness: 1.5, color: Colors.grey[300]),
          SizedBox(height: 5.0),
          Row(
            children: [
              buildPicture(imgUrl),
              SizedBox(width: 20.0),
              buildInformations(username, email, context)
            ],
          ),
        ],
      ),
    );
  }

  Widget buildPicture(String imgUrl){
    return Column(
      children: [
        Text(
          "Profil Fotoğrafı",
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black, width: 1.5),
          ),
          child: CircleAvatar(
            radius: 50.0,
            backgroundImage: imgUrl.isNotEmpty ? NetworkImage(imgUrl) : null,
            child: imgUrl.isEmpty
                ? Icon(Icons.person, size: 50.0, color: Colors.grey[700])
                : null,
          ),
        ),
      ],
    );
  }

  Widget buildInformations(String username, String email, BuildContext context){
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ProfileDetail(
            title: "Kullanıcı Adı:",
            detail: username,
          ),
          SizedBox(height: 10.0),
          ProfileDetail(
            title: "Eposta:",
            detail: email,
          ),
          SizedBox(height: 20.0),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              side: BorderSide(color: Colors.black, width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateUserScreen()),
              );
            },
            child: Text(
              'Bilgilerini Güncelle',
              style: TextStyle(color: Colors.white, fontSize: 16.0),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetail extends StatelessWidget {
  final String title;
  final String detail;

  const ProfileDetail({
    required this.title,
    required this.detail,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        border: Border.all(color: Colors.black, width: 1.5), // Siyah border eklendi
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5.0),
          Text(
            detail,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../blocs/account_bloc.dart';
import '../models/account.dart';
import '../widgets/cart_widget.dart';

class CartScreen extends StatefulWidget {
  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Account?>(
      stream: AccountBloc().getStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Sepet",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              backgroundColor: Colors.lightBlueAccent,
              centerTitle: true,
              elevation: 4.0,
            ),
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Sepet",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              backgroundColor: Colors.lightBlueAccent,
              centerTitle: true,
              elevation: 4.0,
            ),
            body: Center(
              child: Text("Hata: ${snapshot.error}"),
            ),
          );
        } else if (snapshot.hasData && snapshot.data != null) {
          String userId = snapshot.data!.id.toString();
          return CartWidget(context, userId);
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Text(
                "Sepet",
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
              backgroundColor: Colors.lightBlueAccent,
              centerTitle: true,
              elevation: 4.0,
            ),
            body: Center(
              child: Text("Sepetinizi görmek için lütfen giriş yapın."),
            ),
          );
        }
      },
    );
  }
}

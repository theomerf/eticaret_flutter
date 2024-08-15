import 'package:flutter/material.dart';

import '../blocs/account_bloc.dart';
import '../blocs/cart_bloc.dart';
import '../data/account_service.dart';
import 'bottom_navigation_bar_widget.dart';

class OrderWidget extends StatelessWidget{
  final cartItems;
  final userId;

  OrderWidget(this.cartItems, this.userId);

  final _addressController = TextEditingController();
  final _paymentController = TextEditingController();


  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sipariş Verildi'),
          content: Text('Ürünleriniz gönderilmeye hazırlanıyor.'),
          actions: [
            TextButton(
              child: Text('Tamam'),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BottomNavigationBarWidget(initialIndex: 1)),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildCartItems(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPaymentForm(),
              SizedBox(height: 20),
              buildButton(context),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildCartItems(){
    return Expanded(
      child: ListView.builder(
        itemCount: cartItems.length,
        itemBuilder: (context, index) {
          final cartItem = cartItems[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.lightBlueAccent,
              child: Text(
                "${index + 1}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              cartItem.product.name!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Adet: ${cartItem.quantity}'),
            trailing: Text(
              '${(cartItem.product.unitPrice! * cartItem.quantity!).toStringAsFixed(2)} TL',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget buildPaymentForm(){
    return Column(
      children: [
        Text(
          "Teslimat Bilgileri",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _addressController,
          maxLines: 2,
          decoration: InputDecoration(
            labelText: 'Adres',
            hintText: 'Teslimat adresinizi girin',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(Icons.location_on),
          ),
        ),
        SizedBox(height: 20),
        Text(
          "Ödeme Bilgileri",
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _paymentController,
          decoration: InputDecoration(
            labelText: 'Kart Numarası',
            hintText: 'Kart numaranızı girin',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: Icon(Icons.credit_card),
          ),
        ),
        SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Son Kullanma Tarihi',
                  hintText: 'AA/YY',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'CVV',
                  hintText: 'Güvenlik Kodu',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildButton(context){
    return ElevatedButton(
      onPressed: () async {
        double totalPrice = cartItems.fold(
          0,
              (sum, item) => sum + (item.product.unitPrice! * item.quantity!),
        );
        final address = _addressController.text;
        final orderDate = DateTime.now().toString();

        final order = {
          'products': cartItems.map((item) => {
            'id': item.product.id,
            'name': item.product.name,
            'quantity': item.quantity,
            'price': item.product.unitPrice! * item.quantity!,
          }).toList(),
          'totalPrice': totalPrice,
          'address': address,
          'orderDate': orderDate,
        };

        final currentUser = await AccountService.getCurrentUser();
        if (currentUser != null) {
          await AccountBloc().addOrderToUser(currentUser.uid, order);
        }

        await cartBloc.emptyCart(userId);

        _showSuccessDialog(context);
      },
      child: Text('Siparişi Tamamla'),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.lightBlueAccent,
        minimumSize: Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
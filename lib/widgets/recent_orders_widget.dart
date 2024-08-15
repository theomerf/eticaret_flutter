import 'package:flutter/material.dart';

import '../blocs/account_bloc.dart';
import '../models/account.dart';

class RecentOrdersWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        final horizontalPadding = screenWidth * 0.04;
        final cardMargin = EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 10.0);
        final cardPadding = EdgeInsets.all(screenWidth * 0.04);
        return buildWidget(screenWidth, cardMargin, cardPadding);
      },
    );
  }

  Widget buildWidget(double screenWidth, EdgeInsets cardMargin, EdgeInsets cardPadding){
    return StreamBuilder<Account?>(
      stream: AccountBloc().getStream,
      builder: (context, snapshot){
        if (snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }
        else if(snapshot.hasError){
          return Center(child: Text("Hata: ${snapshot.error}"));
        }
        else if(snapshot.hasData && snapshot.data != null){
          if (snapshot.data!.orders != null){
            final orders = snapshot.data!.orders!.toList();
            return buildBody(orders, screenWidth, cardMargin, cardPadding);
          }
          else{
            return Center(
              child: Text(
                "Geçmiş siparişler bulunmuyor.",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: screenWidth * 0.04,
                ),
              ),
            );
          }
        }
        else{
          return Center(
            child: Text(
              "Geçmiş siparişler bulunmuyor.",
              style: TextStyle(
                color: Colors.black54,
                fontSize: screenWidth * 0.04,
              ),
            ),
          );
        }
      },
    );
  }

  Widget buildBody(List orders, double screenWidth, EdgeInsets cardMargin, EdgeInsets cardPadding){
    return Container(
      height: 500, // Container'ın sabit yüksekliği
      margin: cardMargin,
      padding: cardPadding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(screenWidth * 0.04),
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
              "Geçmiş Siparişler",
              style: TextStyle(
                fontSize: screenWidth * 0.05,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
          SizedBox(height: screenWidth * 0.02),
          Divider(thickness: 1.5, color: Colors.grey[300]),
          SizedBox(height: screenWidth * 0.02),
          buildOrderList(orders, screenWidth)
        ],
      )
    );
  }

  Widget buildOrderList(orders, double screenWidth){
    return Expanded(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: screenWidth * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.lightBlueAccent,
                      radius: screenWidth * 0.05,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.03),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Tarih: ${order['orderDate']}",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Toplam Fiyat: ${order['totalPrice'].toStringAsFixed(2)} TL",
                          style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 1.0, color: Colors.grey[300]),
                buildOrderSublist(order, screenWidth)
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildOrderSublist(order, screenWidth){
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: order['products'].length,
      itemBuilder: (context, productIndex) {
        final product = order['products'][productIndex];
        return Padding(
          padding: EdgeInsets.symmetric(vertical: screenWidth * 0.01),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${product['name']} (Adet: ${product['quantity']})",
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black87,
                ),
              ),
              Text(
                "${product['price'].toStringAsFixed(2)} TL",
                style: TextStyle(
                  fontSize: screenWidth * 0.035,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
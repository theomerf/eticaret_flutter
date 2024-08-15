import 'package:alisverisproje/widgets/recent_orders_widget.dart';
import 'package:flutter/material.dart';
import 'package:alisverisproje/widgets/account_topbar_widget.dart';
import 'package:alisverisproje/widgets/profile_info_widget.dart';

class AccountScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hesabım"),
        backgroundColor: Colors.lightBlueAccent,
        centerTitle: true,
        elevation: 4.0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          return buildBody(screenWidth);
        },
      ),
    );
  }

  Widget buildBody(double screenWidth) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AccountTopbarWidget(),
          SizedBox(height: screenWidth * 0.05),
          ProfileInfoWidget(),
          SizedBox(height: screenWidth * 0.05),
          RecentOrdersWidget()
        ],
      ),
    );
  }
}

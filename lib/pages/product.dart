import 'package:flutter/material.dart';
import 'dart:async';
import '../widgets/uielements/title_default.dart';

class ProductPage extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String description;
  final double price;
  ProductPage(this.title, this.imageUrl, this.price, this.description);

  Widget _buildAddressPriceRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Some Address',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text('\$${price.toString()}',
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          print('backbutton');
          Navigator.pop(context, false);
          return Future.value(false);
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(title),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(imageUrl),
              TitleDefault(title),
              _buildAddressPriceRow(),
              Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.center,
                child: Text(
                  description,
                  textAlign: TextAlign.center,
                ),
              )
            ],
          ),
        ));
  }
}

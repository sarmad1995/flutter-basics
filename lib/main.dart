import 'package:flutter/material.dart';
import 'product_manager.dart';
import 'package:flutter/rendering.dart';

void main() {
//  debugPaintSizeEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.deepPurple),
        home: Scaffold(
          appBar: AppBar(
            title: Text('Easy List'),
          ),
          body: ProductManager(startingProduct: 'Food Testerr'),
        ));
  }
}

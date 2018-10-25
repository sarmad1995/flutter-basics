import 'package:flutter/material.dart';
import 'package:flutter_basic_app/product_manager.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     drawer: Drawer(
       child: Column(
         children: <Widget>[
           AppBar(automaticallyImplyLeading: false, title: Text('Choose'),),
           ListTile(title: Text('Manage Products'), onTap: () {},)
         ],
       ),),
     appBar: AppBar(
       title: Text('Easy List'),
     ),
     body: ProductManager(),
   );
  }

}
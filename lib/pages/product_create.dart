import 'package:flutter/material.dart';

class ProductCreatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
     return Center(
      child: RaisedButton(child: Text('Save'), onPressed: () {
        showModalBottomSheet(context: context, builder: (BuildContext conext) {
          return Center(child: Text('This is a modal'),);
        });
      },),
    );
  }

}
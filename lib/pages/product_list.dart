import 'package:flutter/material.dart';
import './product_edit.dart';
import '../scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProductListPage extends StatelessWidget {
  Widget _buildEditIcon(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectProduct(index);
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (BuildContext context) {
          return ProductEditPage();
        }));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            onDismissed: (DismissDirection direction) {
              model.selectProduct(index);
              if (direction == DismissDirection.endToStart) {
                model.deleteProduct();
                print('swipers end to start');
              } else if (direction == DismissDirection.startToEnd) {
                print('swiped start to end');
              }
            },
            background: Container(
              color: Colors.red,
            ),
            key: Key(model.products[index].title),
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                    backgroundImage: AssetImage(
                      model.products[index].image,
                    ),
                  ),
                  title: Text(model.products[index].title),
                  subtitle: Text('\$${model.products[index].price.toString()}'),
                  trailing: _buildEditIcon(context, index, model),
                ),
                Divider()
              ],
            ),
          );
        },
        itemCount: model.allProducts.length,
      );
    });
  }
}

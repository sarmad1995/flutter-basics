import 'package:flutter/material.dart';
import './widgets/product/product_card.dart';
import 'package:scoped_model/scoped_model.dart';

import './models/product.dart';
import './scoped-models/main.dart';

class Products extends StatelessWidget {
  Widget _buildProductList(List<Product> products) {
    Widget productCards = Center(
      child: Text('No Products found please add some'),
    );
    if (products.length > 0) {
      productCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ProductCard(products[index], index),
        itemCount: products.length,
      );
    }
    return productCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildProductList(model.displayedProducts);
      },
    );
  }
}

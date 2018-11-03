import 'package:flutter/material.dart';
import '../helpers/ensure-visible.dart';

class ProductEditPage extends StatefulWidget {
  final Function addProduct;
  final Function updateProduct;
  final Map<String, dynamic> product;
  final int productIndex;
  ProductEditPage(
      {this.product, this.addProduct, this.updateProduct, this.productIndex});

  @override
  State<StatefulWidget> createState() {
    return _ProductEditPageState();
  }
}

class _ProductEditPageState extends State<ProductEditPage> {
  final Map<String, dynamic> _formData = {
    'title': null,
    'description': null,
    'price': null,
    'image': 'assets/food.jpg'
  };
  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final priceFocusNode = FocusNode();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Widget _buildTitleTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: titleFocusNode,
        child: TextFormField(
            focusNode: titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            initialValue: widget.product == null ? '' : widget.product['title'],
            validator: (String value) {
              if (value.isEmpty || value.length < 5) {
                return 'Title should be more then 5 characters';
              }
            },
            onSaved: (String value) => _formData['title'] = value));
  }

  Widget _buildDescriptionTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: descriptionFocusNode,
        child: TextFormField(
            focusNode: descriptionFocusNode,
            decoration: InputDecoration(labelText: 'Product Description'),
            initialValue:
                widget.product == null ? '' : widget.product['description'],
            validator: (String value) {
              if (value.isEmpty || value.length < 10) {
                return 'Description  should be more then 10 characters';
              }
            },
            maxLines: 4,
            onSaved: (String value) => _formData['description'] = value));
  }

  Widget _buildPriceTextField() {
    return EnsureVisibleWhenFocused(
        focusNode: priceFocusNode,
        child: TextFormField(
            focusNode: priceFocusNode,
            decoration: InputDecoration(labelText: 'Product Price'),
            initialValue: widget.product == null
                ? ''
                : widget.product['price'].toString(),
            validator: (String value) {
              if (value.isEmpty ||
                  !RegExp(r'^(?:[1-9]\d*|0)?(?:\.\d+)?$').hasMatch(value)) {
                return 'Price is required and should be number';
              }
            },
            keyboardType: TextInputType.number,
            onSaved: (String value) =>
                _formData['price'] = double.parse(value)));
  }

  void _submitForm() {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (widget.product == null) {
      widget.addProduct(_formData);
    } else {
      widget.updateProduct(widget.productIndex, _formData);
    }
    Navigator.pushReplacementNamed(context, '/products');
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    final Widget pageContent = GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                children: <Widget>[
                  _buildTitleTextField(),
                  _buildDescriptionTextField(),
                  _buildPriceTextField(),
                  SizedBox(
                    height: 10.0,
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    textColor: Colors.white,
                    child: Text('Save'),
                    onPressed: _submitForm,
                  )
                ],
              ),
            )));
    return widget.product == null
        ? pageContent
        : Scaffold(
            appBar: AppBar(title: Text('Edit Product')),
            body: pageContent,
          );
  }
}

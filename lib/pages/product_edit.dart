import 'package:flutter/material.dart';
import '../helpers/ensure-visible.dart';
import '../models/product.dart';
import 'package:scoped_model/scoped_model.dart';
import '../scoped-models/main.dart';

class ProductEditPage extends StatefulWidget {
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
  Widget _buildTitleTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: titleFocusNode,
        child: TextFormField(
            focusNode: titleFocusNode,
            decoration: InputDecoration(labelText: 'Product Title'),
            initialValue: product == null ? '' : product.title,
            validator: (String value) {
              if (value.isEmpty || value.length < 5) {
                return 'Title should be more then 5 characters';
              }
            },
            onSaved: (String value) => _formData['title'] = value));
  }

  Widget _buildDescriptionTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: descriptionFocusNode,
        child: TextFormField(
            focusNode: descriptionFocusNode,
            decoration: InputDecoration(labelText: 'Product Description'),
            initialValue: product == null ? '' : product.description,
            validator: (String value) {
              if (value.isEmpty || value.length < 10) {
                return 'Description  should be more then 10 characters';
              }
            },
            maxLines: 4,
            onSaved: (String value) => _formData['description'] = value));
  }

  Widget _buildPriceTextField(Product product) {
    return EnsureVisibleWhenFocused(
        focusNode: priceFocusNode,
        child: TextFormField(
            focusNode: priceFocusNode,
            decoration: InputDecoration(labelText: 'Product Price'),
            initialValue: product == null ? '' : product.price.toString(),
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

  void _submitForm(
      Function addProduct, Function updateProduct, Function setSelectedProduct,
      [int selectedProductIndex]) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    if (selectedProductIndex == null) {
      final response = await addProduct(_formData['title'],
          _formData['description'], _formData['image'], _formData['price']);
      if (response) {
        Navigator.pushReplacementNamed(context, '/products')
            .then((_) => setSelectedProduct(null));
      }
    } else {
      final response = updateProduct(_formData['title'],
          _formData['description'], _formData['image'], _formData['price']);
      if (response) {
        Navigator.pushReplacementNamed(context, '/products')
            .then((_) => setSelectedProduct(null));
      }
    }
  }

  Widget _buildSubmitButton() {
    return ScopedModelDescendant(
      builder: (BuildContext context, Widget child, MainModel model) {
        return model.isLoading
            ? Center(child: CircularProgressIndicator())
            : RaisedButton(
                color: Theme.of(context).accentColor,
                textColor: Colors.white,
                child: Text('Save'),
                onPressed: () => _submitForm(
                    model.addProduct,
                    model.updateProduct,
                    model.selectProduct,
                    model.selectedProductIndex),
              );
      },
    );
  }

  Widget _buildPageContent(BuildContext context, Product product) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;
    final double targetPadding = deviceWidth - targetWidth;
    return GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: Container(
            margin: EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: targetPadding / 2),
                children: <Widget>[
                  _buildTitleTextField(product),
                  _buildDescriptionTextField(product),
                  _buildPriceTextField(product),
                  SizedBox(
                    height: 10.0,
                  ),
                  _buildSubmitButton()
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        final Widget pageContent =
            _buildPageContent(context, model.selectedProduct);

        return model.selectedProductIndex == null
            ? pageContent
            : Scaffold(
                appBar: AppBar(title: Text('Edit Product')),
                body: pageContent,
              );
      },
    );
  }
}

import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import '../models/product.dart';
import '../models/user.dart';
import '../models/auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

class ConnectedProductsModel extends Model {
  List<Product> _products = [];
  User _authenticatedUser;
  String _selfProductId;
  bool _isLoading = false;

  Future<bool> addProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> productData = {
      'title': title,
      'description': description,
      'image':
          'https://cdn.pixabay.com/photo/2015/10/02/12/00/chocolate-968457_960_720.jpg',
      'price': price,
      'userEmail': _authenticatedUser.email,
      'userId': _authenticatedUser.id
    };
    try {
      final http.Response response = await http.post(
          'https://flutter-products-fcd4d.firebaseio.com/products.json?auth=${_authenticatedUser.token}',
          body: json.encode(productData));
      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);
      final Product newProduct = Product(
          id: responseData['name'],
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: _authenticatedUser.email,
          userId: _authenticatedUser.id);
      _products.add(newProduct);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}

class ProductsModel extends ConnectedProductsModel {
  bool _showFavorites = false;
  List<Product> get allProducts {
    return List.from(_products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return _products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(_products);
  }

  int get selectedProductIndex {
    return _products
        .indexWhere((Product product) => product.id == _selfProductId);
  }

  String get selectedProductId {
    return _selfProductId;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Product get selectedProduct {
    if (selectedProductId == null) {
      return null;
    }
    return _products
        .firstWhere((Product product) => product.id == selectedProductId);
  }

  Future<bool> deleteProduct() async {
    try {
      _isLoading = true;
      final deletedProduct = selectedProduct.id;
      _products.removeAt(selectedProductIndex);
      _selfProductId = null;
      notifyListeners();
      final response = await http.delete(
          'https://flutter-products-fcd4d.firebaseio.com/products/${deletedProduct}.json?auth=${_authenticatedUser.token}');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> fetchProducts({onlyForUser: false}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await http.get(
          'https://flutter-products-fcd4d.firebaseio.com/products.json?auth=${_authenticatedUser.token}');
      print(json.decode(response.body));
      final List<Product> fetchedProductList = [];
      final Map<String, dynamic> productListData = json.decode(response.body);
      if (productListData == null) {
        _isLoading = false;
        notifyListeners();
        return true;
      }
      productListData.forEach((String productId, dynamic productData) {
        final Product product = Product(
            id: productId,
            title: productData['title'],
            description: productData['description'],
            image: productData['image'],
            price: productData['price'],
            userEmail: productData['userEmail'],
            isFavorite: productData['wishlistUsers'] == null
                ? false
                : (productData['wishlistUsers'] as Map<String, dynamic>)
                    .containsKey(_authenticatedUser.id),
            userId: productData['userId']);
        fetchedProductList.add(product);
      });
      _products = fetchedProductList
          .where((Product product) => product.userId == _authenticatedUser.id)
          .toList();
      _isLoading = false;
      _selfProductId = null;
      notifyListeners();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  void toggleProductFavoriteStatus() async {
    final bool isCurrentlyFavorite = _products[selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      id: selectedProduct.id,
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: _authenticatedUser.email,
      userId: _authenticatedUser.id,
      isFavorite: newFavoriteStatus,
    );
    _products[selectedProductIndex] = updatedProduct;
    notifyListeners();
    http.Response response;
    if (newFavoriteStatus) {
      response = await http.put(
          'https://flutter-products-fcd4d.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}',
          body: json.encode(true));
      if (response.statusCode != 200 && response.statusCode != 201) {}
    } else {
      response = await http.delete(
          'https://flutter-products-fcd4d.firebaseio.com/products/${selectedProduct.id}/wishlistUsers/${_authenticatedUser.id}.json?auth=${_authenticatedUser.token}');
    }
    print(json.decode(response.body));
    if (response.statusCode != 200 && response.statusCode != 201) {
      final Product updatedProduct = Product(
        id: selectedProduct.id,
        title: selectedProduct.title,
        description: selectedProduct.description,
        price: selectedProduct.price,
        image: selectedProduct.image,
        userEmail: _authenticatedUser.email,
        userId: _authenticatedUser.id,
        isFavorite: !newFavoriteStatus,
      );
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
    }
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  Future<bool> updateProduct(
      String title, String description, String image, double price) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updatedData = {
      'title': title,
      'description': description,
      'image':
          'https://cdn.pixabay.com/photo/2015/10/02/12/00/chocolate-968457_960_720.jpg',
      'price': price,
      'userEmail': selectedProduct.userEmail,
      'userId': selectedProduct.userId
    };
    try {
      final reponse = await http.put(
          'https://flutter-products-fcd4d.firebaseio.com/products/${selectedProduct.id}.json',
          body: json.encode(updatedData));
      _isLoading = false;
      final Product updatedProduct = Product(
          id: selectedProduct.id,
          title: title,
          description: description,
          image: image,
          price: price,
          userEmail: selectedProduct.userEmail,
          userId: selectedProduct.userId);
      _products[selectedProductIndex] = updatedProduct;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  void selectProduct(String productId) {
    _selfProductId = productId;
    notifyListeners();
  }
}

class UserModel extends ConnectedProductsModel {
  PublishSubject<bool> _userSubject = PublishSubject();
  Timer _authTimer;
  User get user {
    return _authenticatedUser;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [AuthMode mode = AuthMode.Login]) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      "email": email.trim(),
      "password": password.trim(),
      "returnSecureToken": true
    };
    http.Response response;
    try {
      if (mode == AuthMode.Login) {
        response = await http.post(
            'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBDVEKK_lsmk2tyj4tHj89bmoJMgLjFufU',
            body: json.encode(authData));
      } else {
        response = await http.post(
            'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBDVEKK_lsmk2tyj4tHj89bmoJMgLjFufU',
            body: json.encode(authData));
      }

      final Map<String, dynamic> responseData = json.decode(response.body);
      bool hasError = true;
      String message = 'Something went wrong';
      if (responseData.containsKey('idToken')) {
        hasError = false;
        message = 'Authentication succeeded';
        _authenticatedUser = User(
            id: responseData['localId'],
            email: email,
            token: responseData['idToken']);
        // Settings user data
        setAuthTimeout(int.parse(responseData['expiresIn']));
        _userSubject.add(true);
        final DateTime now = DateTime.now();
        final DateTime expiryTime =
            now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('token', responseData['idToken']);
        prefs.setString('userEmail', email);
        prefs.setString('userId', responseData['localId']);
        prefs.setString('expiryTime', expiryTime.toIso8601String());
      } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
        message = 'This email was not found';
      } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
        message = 'The Password is invalid';
      } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
        message = 'This email already exists';
      }
      _isLoading = false;
      notifyListeners();
      return {"success": !hasError, 'message': message};
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return {'success': false, 'message': 'Internet Connectivity problem'};
    }
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        notifyListeners();
        return;
        // EXPIRED
      }
      final String userEmail = prefs.get('userEmail');
      final String userId = prefs.get('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(email: userEmail, token: token, id: userId);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      notifyListeners();
    }
  }

  void logout() async {
    print('Logout');
    _authenticatedUser = null;
    _authTimer.cancel();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userId');
    prefs.remove('userEmail');
    _userSubject.add(false);
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), () {
      logout();
    });
  }
}

class UtilityModel extends ConnectedProductsModel {
  bool get isLoading {
    return _isLoading;
  }
}
// mixin UserModel on ConnectedProductsModel {...}
// mixin ProductsModel on ConnectedProductsModel {...}

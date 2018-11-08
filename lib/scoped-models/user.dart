import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';
import './connected_products.dart';

class UserModel extends ConnectedProducts {
  void login(String email, String password) {
    print(email);
    print(password);
    authenticatedUser = User(id: 'id', email: email, password: password);
  }
}
// mixin UserModel on ConnectedProductsModel {...}
// mixin ProductsModel on ConnectedProductsModel {...}

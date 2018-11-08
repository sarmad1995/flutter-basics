import 'package:scoped_model/scoped_model.dart';
import '../models/user.dart';

class UserModel extends Model {
  User _authenticatedUser;
  void login(String email, String password) {
    print(email);
    print(password);
    _authenticatedUser = User(id: 'id', email: email, password: password);
  }
}
// mixin UserModel on ConnectedProductsModel {...}
// mixin ProductsModel on ConnectedProductsModel {...}

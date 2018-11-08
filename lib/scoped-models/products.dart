import 'package:scoped_model/scoped_model.dart';
import '../models/product.dart';
import './connected_products.dart';

class ProductsModel extends ConnectedProducts {
  bool _showFavorites = false;
  List<Product> get allProducts {
    return List.from(products);
  }

  List<Product> get displayedProducts {
    if (_showFavorites) {
      return products.where((Product product) => product.isFavorite).toList();
    }
    return List.from(products);
  }

  int get selectedProductIndex {
    return selfProductIndex;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  Product get selectedProduct {
    if (selectedProductIndex == null) {
      return null;
    }
    return products[selectedProductIndex];
  }

  void deleteProduct() {
    products.removeAt(selectedProductIndex);
    selfProductIndex = null;
  }

  void toggleProductFavoriteStatus() {
    final bool isCurrentlyFavorite = products[selectedProductIndex].isFavorite;
    final bool newFavoriteStatus = !isCurrentlyFavorite;
    final Product updatedProduct = Product(
      title: selectedProduct.title,
      description: selectedProduct.description,
      price: selectedProduct.price,
      image: selectedProduct.image,
      userEmail: authenticatedUser.email,
      userId: authenticatedUser.id,
      isFavorite: newFavoriteStatus,
    );
    products[selectedProductIndex] = updatedProduct;
    selfProductIndex = null;
    notifyListeners();
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
    selfProductIndex = null;
  }

  void updateProduct(
      String title, String description, String image, double price) {
    final Product updatedProduct = Product(
        title: title,
        description: description,
        image: image,
        price: price,
        userEmail: selectedProduct.userEmail,
        userId: selectedProduct.userId);
    products[selectedProductIndex] = updatedProduct;
    selfProductIndex = null;
    notifyListeners();
  }

  void selectProduct(int index) {
    selfProductIndex = index;
    notifyListeners();
  }
}

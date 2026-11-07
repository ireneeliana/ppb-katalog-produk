import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../services/api_service_products.dart';

class ProductProvider with ChangeNotifier {
  final ApiServiceProducts _apiService = ApiServiceProducts();
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();
    try {
      _products = await _apiService.getProducts();
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addProduct(String title, double price, String description, String category) async {
    try {
      final newProduct = await _apiService.addProduct(title, price, description, category);
      _products.insert(0, newProduct);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateProduct(int id, String title, double price, String description) async {
    try {
      final updatedProduct = await _apiService.updateProduct(id, title, price, description);
      final index = _products.indexWhere((p) => p.id == id);
      if (index != -1) {
        _products[index] = updatedProduct;
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(int id) async {
    try {
      final success = await _apiService.deleteProduct(id);
      if (success) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
      }
      return true;
    } catch (e) {
      return false;
    }
  }
}
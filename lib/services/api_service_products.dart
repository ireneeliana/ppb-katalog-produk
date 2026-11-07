import 'package:dio/dio.dart';
import '../models/product_model.dart';

class ApiServiceProducts {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://dummyjson.com',
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // GET: Read Products
  Future<List<Product>> getProducts() async {
    try {
      final response = await _dio.get('/products');
      final List data = response.data['products'];
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }

  // POST: Create Product
  Future<Product> addProduct(String title, double price, String description, String category) async {
    try {
      final response = await _dio.post('/products/add', data: {
        'title': title,
        'price': price,
        'description': description,
        'category': category,
        'thumbnail': 'https://dummyjson.com/image/150',
      });
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal menambah produk: $e');
    }
  }

  // PUT: Update Product
  Future<Product> updateProduct(int id, String title, double price, String description) async {
    try {
      final response = await _dio.put('/products/$id', data: {
        'title': title,
        'price': price,
        'description': description,
      });
      return Product.fromJson(response.data);
    } catch (e) {
      throw Exception('Gagal memperbarui produk: $e');
    }
  }

  // DELETE: Delete Product
  Future<bool> deleteProduct(int id) async {
    try {
      await _dio.delete('/products/$id');
      return true;
    } catch (e) {
      throw Exception('Gagal menghapus produk: $e');
    }
  }
}
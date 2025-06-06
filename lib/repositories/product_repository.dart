import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductRepository {
 Future<List<Product>> fetchProductsByCategoryId(int categoryId, {int page = 1}) async {
  final url = Uri.parse('http://mobile-shop-api.hiring.devebs.net/products?category=$categoryId&page=$page');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final results = data['results'] as List;
    return results.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products by category ID');
  }
}

  Future<Map<String, dynamic>> fetchProductDetail(int id) async {
    final url = Uri.parse('http://mobile-shop-api.hiring.devebs.net/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load product details');
    }
  }


  Future<List<Product>> fetchProducts({int page = 1}) async {
    final url = Uri.parse('http://mobile-shop-api.hiring.devebs.net/products?page=$page');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final productsJson = data['results'] as List;
      return productsJson.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<Product> fetchProductById(int id) async {
    final url = Uri.parse('http://mobile-shop-api.hiring.devebs.net/products/$id');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Product.fromJson(data);
    } else {
      throw Exception('Failed to load product details');
    }
  }
}

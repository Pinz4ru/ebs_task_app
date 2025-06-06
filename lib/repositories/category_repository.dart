import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/category.dart';

class CategoryRepository {
  Future<List<Category>> fetchCategories() async {
    final url = Uri.parse('http://mobile-shop-api.hiring.devebs.net/categories');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final categoriesJson = data['results'] as List;
      return categoriesJson.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

   Future<List<Category>> fetchCategoriesFromProducts() async {
    final url = Uri.parse('http://mobile-shop-api.hiring.devebs.net/products');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final results = data['results'] as List;

      final categoryMap = <int, Category>{};

      for (var product in results) {
        final catJson = product['category'];
        if (catJson != null) {
          final cat = Category.fromJson(catJson);
          categoryMap[cat.id] = cat; // Ensures uniqueness by ID
        }
      }

      return categoryMap.values.toList();
    } else {
      throw Exception('Failed to fetch categories');
    }
  }
}

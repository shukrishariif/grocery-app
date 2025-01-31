// lib/services/product_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      print('Fetching all products from: $baseUrl/products');
      final response = await http.get(
        Uri.parse('$baseUrl/products'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('Get products request timed out');
          throw Exception('Connection timed out. Please try again.');
        },
      );

      print('Get products response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Get products error: $e');
      throw Exception('Failed to load products: $e');
    }
  }

  // Get products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      print('Fetching products by category: $category');
      final response = await http.get(
        Uri.parse('$baseUrl/products?category=$category'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timed out'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load products by category');
      }
    } catch (e) {
      print('Get products by category error: $e');
      throw Exception('Failed to load products by category: $e');
    }
  }

  // Get single product
  Future<Product> getProductById(String id) async {
    try {
      print('Fetching product details: $id');
      final response = await http.get(
        Uri.parse('$baseUrl/products/$id'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timed out'),
      );

      if (response.statusCode == 200) {
        return Product.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load product details');
      }
    } catch (e) {
      print('Get product details error: $e');
      throw Exception('Failed to load product details: $e');
    }
  }

  // Search products
  Future<List<Product>> searchProducts(String query) async {
    try {
      print('Searching products: $query');
      final response = await http.get(
        Uri.parse('$baseUrl/products/search?query=$query'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timed out'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      print('Search products error: $e');
      throw Exception('Failed to search products: $e');
    }
  }
}

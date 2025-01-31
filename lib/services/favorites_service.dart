// lib/services/favorites_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/product.dart';
import 'api_service.dart';

class FavoritesService {
  final String baseUrl = 'http://10.0.2.2:5000/api';
  final ApiService _apiService = ApiService();

  Future<List<Product>> getFavorites() async {
    try {
      final token = await _apiService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timed out'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print('Get favorites error: $e');
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<void> addToFavorites(String productId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/favorites/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timed out'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add to favorites');
      }
    } catch (e) {
      print('Add to favorites error: $e');
      throw Exception('Failed to add to favorites: $e');
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    try {
      final token = await _apiService.getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/favorites/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Connection timed out'),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from favorites');
      }
    } catch (e) {
      print('Remove from favorites error: $e');
      throw Exception('Failed to remove from favorites: $e');
    }
  }
}

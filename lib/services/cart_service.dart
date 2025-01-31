// lib/services/cart_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';

class CartService {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  // Get Cart
  Future<List<CartItem>> getCart() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/cart'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return (data['items'] as List)
            .map((item) => CartItem.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      print('Get cart error: $e');
      rethrow;
    }
  }

  // Add to Cart
  Future<void> addToCart({
    required String productId,
    required String name,
    required double price,
    required int quantity,
    required String imageUrl,
  }) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.post(
        Uri.parse('$baseUrl/cart/add'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'productId': productId,
          'name': name,
          'price': price,
          'quantity': quantity,
          'imageUrl': imageUrl,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      print('Add to cart error: $e');
      rethrow;
    }
  }

  // Update Cart Item
  Future<void> updateCartItem(String productId, int quantity) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/cart/update/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'quantity': quantity}),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update cart');
      }
    } catch (e) {
      print('Update cart error: $e');
      rethrow;
    }
  }

  // Remove from Cart
  Future<void> removeFromCart(String productId) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/cart/remove/$productId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove from cart');
      }
    } catch (e) {
      print('Remove from cart error: $e');
      rethrow;
    }
  }

  // Clear Cart
  Future<void> clearCart() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.delete(
        Uri.parse('$baseUrl/cart/clear'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to clear cart');
      }
    } catch (e) {
      print('Clear cart error: $e');
      rethrow;
    }
  }
}

// lib/services/order_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

class OrderService {
  final String baseUrl = 'http://10.0.2.2:5000/api';
  final Duration timeout = const Duration(seconds: 10);

  // Get token helper method
  Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('token');
    } catch (e) {
      print('Error getting token: $e');
      return null;
    }
  }

  // Create Order
  // lib/services/order_service.dart
  Future<Order> createOrder({
    required List<CartItem> items,
    required double totalAmount,
    required String address,
    required String phone,
    required String paymentMethod,
  }) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      // Debug print the request payload
      final payload = {
        'items': items
            .map((item) => {
                  'productId': item.id,
                  'quantity': item.quantity,
                  'price': item.price,
                  'name': item.name,
                  'imageUrl': item.imageUrl,
                })
            .toList(),
        'totalAmount': totalAmount,
        'shippingAddress': {
          'address': address,
          'phone': phone,
        },
        'paymentMethod': paymentMethod,
      };
      print('Request payload: ${jsonEncode(payload)}');

      final response = await http
          .post(
            Uri.parse('$baseUrl/orders'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
            body: jsonEncode(payload),
          )
          .timeout(timeout);

      print('Create order response status: ${response.statusCode}');
      print('Create order response body: ${response.body}');

      if (response.statusCode == 201) {
        final orderData = jsonDecode(response.body);
        return Order.fromJson(orderData);
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception(
            'Failed to create order: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      print('Create order error: $e');
      rethrow;
    }
  }

  // Get All Orders
  Future<List<Order>> getOrders() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/orders'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(timeout);

      print('Get orders response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Order.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else {
        throw Exception(
            'Failed to load orders: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      print('Get orders error: $e');
      rethrow;
    }
  }

  // Get Single Order
  Future<Order> getOrderById(String orderId) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/orders/$orderId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(timeout);

      print('Get order by id response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return Order.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized - Please login again');
      } else if (response.statusCode == 404) {
        throw Exception('Order not found');
      } else {
        throw Exception(
            'Failed to load order: ${response.statusCode} - ${response.body}');
      }
    } on TimeoutException {
      throw Exception('Connection timed out. Please try again.');
    } catch (e) {
      print('Get order by id error: $e');
      rethrow;
    }
  }

  // Test Connection
  Future<bool> testConnection() async {
    try {
      final response = await http
          .get(
            Uri.parse('$baseUrl/test'),
          )
          .timeout(const Duration(seconds: 5));

      print('Test connection response: ${response.statusCode}');
      print('Response body: ${response.body}');

      return response.statusCode == 200;
    } on TimeoutException {
      print('Connection test timed out');
      return false;
    } catch (e) {
      print('Test connection error: $e');
      return false;
    }
  }

  // Debug Connection
  Future<Map<String, dynamic>> debugConnection() async {
    final results = <String, dynamic>{};

    try {
      // Test basic connection
      results['basicConnection'] = await testConnection();

      // Get and check token
      final token = await getToken();
      results['hasToken'] = token != null;

      if (token != null) {
        // Test authenticated endpoint
        try {
          final ordersResponse = await http.get(
            Uri.parse('$baseUrl/orders'),
            headers: {
              'Authorization': 'Bearer $token',
              'Content-Type': 'application/json',
            },
          ).timeout(const Duration(seconds: 5));

          results['ordersEndpoint'] = {
            'statusCode': ordersResponse.statusCode,
            'isSuccessful': ordersResponse.statusCode == 200,
          };
        } catch (e) {
          results['ordersEndpoint'] = {
            'error': e.toString(),
            'isSuccessful': false,
          };
        }
      }

      return results;
    } catch (e) {
      print('Debug connection error: $e');
      return {'error': e.toString()};
    }
  }
}

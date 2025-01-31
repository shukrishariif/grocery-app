// lib/models/order.dart
import 'package:g1/models/cart_item.dart';

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String imageUrl;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.imageUrl,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    // Handle both nested and flat product data structures
    final productData = json['productId'] is Map ? json['productId'] : json;

    return OrderItem(
      id: productData['_id']?.toString() ?? productData['id']?.toString() ?? '',
      name: productData['name']?.toString() ?? '',
      price: double.tryParse(productData['price']?.toString() ?? '') ?? 0.0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      imageUrl: productData['imageUrl']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'imageUrl': imageUrl,
    };
  }

  // Add a method to create OrderItem from CartItem
  static OrderItem fromCartItem(CartItem cartItem) {
    return OrderItem(
      id: cartItem.id,
      name: cartItem.name,
      price: cartItem.price,
      quantity: cartItem.quantity,
      imageUrl: cartItem.imageUrl,
    );
  }
}

class Order {
  final String id;
  final List<OrderItem> items;
  final double totalAmount;
  final String status;
  final String paymentMethod;
  final DateTime createdAt;
  final Map<String, String> shippingAddress;

  Order({
    required this.id,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentMethod,
    required this.createdAt,
    required this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    try {
      return Order(
        id: json['_id']?.toString() ?? '',
        items: (json['items'] as List<dynamic>?)
                ?.map((item) => OrderItem.fromJson(item))
                .toList() ??
            [],
        totalAmount:
            double.tryParse(json['totalAmount']?.toString() ?? '') ?? 0.0,
        status: json['status']?.toString()?.toLowerCase() ?? 'pending',
        paymentMethod: json['paymentMethod']?.toString() ?? 'Cash on Delivery',
        createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
        shippingAddress:
            (json['shippingAddress'] as Map<String, dynamic>?)?.map(
                  (key, value) => MapEntry(key, value?.toString() ?? ''),
                ) ??
                {'address': '', 'phone': ''},
      );
    } catch (e) {
      print('Error parsing Order from JSON: $e');
      // Return a default order in case of parsing errors
      return Order(
        id: '',
        items: [],
        totalAmount: 0.0,
        status: 'pending',
        paymentMethod: 'Cash on Delivery',
        createdAt: DateTime.now(),
        shippingAddress: {'address': '', 'phone': ''},
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status,
      'paymentMethod': paymentMethod,
      'createdAt': createdAt.toIso8601String(),
      'shippingAddress': shippingAddress,
    };
  }

  // Helper method to calculate total items
  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  // Helper method to check if order is in progress
  bool get isInProgress =>
      status.toLowerCase() == 'pending' || status.toLowerCase() == 'processing';

  // Helper method to check if order is completed
  bool get isCompleted =>
      status.toLowerCase() == 'delivered' ||
      status.toLowerCase() == 'cancelled';
}

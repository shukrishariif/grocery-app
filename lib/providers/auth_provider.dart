// lib/providers/auth_provider.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../models/product.dart';
import '../models/order.dart';
import '../models/contact_message.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  User? _user;
  bool _isAuthenticated = false;
  bool _isLoading = false;
  bool _skipLogin = false;

  // Collections
  List<String> _savedAddresses = [];
  List<String> _paymentMethods = [];
  List<Order> _orderHistory = [];
  List<Product> _cart = [];
  List<Product> _favorites = [];
  List<ContactMessage> _contactMessages = [];

  // Getters
  bool get isAuthenticated => _isAuthenticated;
  bool get isLoading => _isLoading;
  bool get skipLogin => _skipLogin;
  User? get currentUser => _user;
  List<String> get savedAddresses => _savedAddresses;
  List<String> get paymentMethods => _paymentMethods;
  List<Order> get orderHistory => _orderHistory;
  List<Product> get cart => _cart;
  List<Product> get favorites => _favorites;
  List<ContactMessage> get contactMessages => _contactMessages;
  double get cartTotal =>
      _cart.fold(0, (total, product) => total + product.price);

  // Initialize auth state
  Future<void> initializeAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token != null) {
        final userData = prefs.getString('user_data');
        if (userData != null) {
          _user = User.fromJson(json.decode(userData));
          _isAuthenticated = true;
          await _loadUserData();
        }
      }

      _skipLogin = prefs.getBool('skip_login') ?? false;
      notifyListeners();
    } catch (e) {
      print('Initialize auth error: $e');
    }
  }

  // Register
  Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      print('Starting registration with data:');
      print('Name: $name');
      print('Email: $email');
      print('Phone: $phone');
      print('Address: $address');

      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
        address: address,
      );

      print('Full registration response: $response'); // See exact response
      print('Response type: ${response.runtimeType}');
      print('Response keys: ${response.keys.toList()}');

      if (response.containsKey('token') && response.containsKey('user')) {
        final userData = response['user'];
        print('User data received: $userData'); // Debug user data

        _user = User(
          id: userData['id'],
          name: userData['name'],
          email: userData['email'],
          phone: userData['phone'],
          address: address,
          profileImage: 'assets/images/default_profile.png',
        );

        _isAuthenticated = true;
        _skipLogin = false;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(_user!.toJson()));
        await prefs.setString('token', response['token']);
        await prefs.setBool('skip_login', false);

        print('Registration successful with user: ${_user!.toJson()}');
        print('Token saved: ${response['token']}');
        notifyListeners();
        return true;
      }
      print('Registration failed: Invalid response format');
      print('Expected keys "token" and "user", got: ${response.keys.toList()}');
      return false;
    } catch (e) {
      print('Registration error: $e');
      print('Stack trace: ${StackTrace.current}');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Login
  Future<bool> login(String email, String password) async {
    try {
      final response =
          await _apiService.login(email: email, password: password);

      if (response.containsKey('token') && response.containsKey('user')) {
        final userData = response['user'];
        _user = User(
          id: userData['_id'],
          name: userData['name'],
          email: userData['email'],
          phone: userData['phone'],
          address: userData['address'] ?? '',
        );

        _isAuthenticated = true;

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(_user!.toJson()));
        await prefs.setString('token', response['token']);

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Update Profile
  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? address,
    String? profileImage,
  }) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateProfile(
        name: name,
        phone: phone,
        address: address,
      );

      if (response.containsKey('user')) {
        final userData = response['user'];
        _user = _user!.copyWith(
          name: userData['name'] ?? _user!.name,
          phone: userData['phone'] ?? _user!.phone,
          address: userData['address'] ?? _user!.address,
          profileImage: profileImage ?? _user!.profileImage,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(_user!.toJson()));

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update profile error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update Profile Image
  Future<bool> updateProfileImage(String imagePath) async {
    try {
      _isLoading = true;
      notifyListeners();

      final response = await _apiService.updateProfileImage(imagePath);

      if (response.containsKey('user')) {
        final userData = response['user'];
        _user = _user!.copyWith(
          profileImage: userData['profileImage'] ?? _user!.profileImage,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', json.encode(_user!.toJson()));

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('Update profile image error: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add Address
  Future<void> addAddress(String address) async {
    if (!_isAuthenticated) {
      throw Exception('Please login to add address');
    }
    _savedAddresses.add(address);
    await _saveUserData();
    notifyListeners();
  }

  // Update Address
  void updateAddress(int index, String text) {
    if (index < _savedAddresses.length) {
      _savedAddresses[index] = text;
      _saveUserData();
      notifyListeners();
    }
  }

  // Submit Contact Message
  Future<void> submitContactMessage(ContactMessage message) async {
    if (!_isAuthenticated) {
      throw Exception('Please login to submit a message');
    }
    _contactMessages.add(message);
    notifyListeners();
  }

  // Load User Data
  Future<void> _loadUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      _savedAddresses = prefs.getStringList('saved_addresses') ?? [];
      _paymentMethods = prefs.getStringList('payment_methods') ?? [];

      final cartData = prefs.getString('cart_data');
      if (cartData != null) {
        final List<dynamic> decoded = json.decode(cartData);
        _cart = decoded.map((item) => Product.fromJson(item)).toList();
      }

      final favoritesData = prefs.getString('favorites_data');
      if (favoritesData != null) {
        final List<dynamic> decoded = json.decode(favoritesData);
        _favorites = decoded.map((item) => Product.fromJson(item)).toList();
      }

      final orderHistoryData = prefs.getString('order_history');
      if (orderHistoryData != null) {
        final List<dynamic> decoded = json.decode(orderHistoryData);
        _orderHistory = decoded.map((item) => Order.fromJson(item)).toList();
      }
    } catch (e) {
      print('Load user data error: $e');
    }
  }

  // Save User Data
  Future<void> _saveUserData() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setStringList('saved_addresses', _savedAddresses);
      await prefs.setStringList('payment_methods', _paymentMethods);

      final cartData = json.encode(_cart.map((item) => item.toJson()).toList());
      await prefs.setString('cart_data', cartData);

      final favoritesData =
          json.encode(_favorites.map((item) => item.toJson()).toList());
      await prefs.setString('favorites_data', favoritesData);

      final orderHistoryData =
          json.encode(_orderHistory.map((item) => item.toJson()).toList());
      await prefs.setString('order_history', orderHistoryData);
    } catch (e) {
      print('Save user data error: $e');
    }
  }

  // Update User Profile (simplified version)
  void updateUserProfile({required String name, required String phone}) {
    if (_user != null) {
      _user = _user!.copyWith(name: name, phone: phone);
      notifyListeners();
      _saveUserData();
    }
  }

  // Refresh User Data
  Future<void> refreshUserData() async {
    if (_isAuthenticated) {
      await _loadUserData();
      notifyListeners();
    }
  }

  // Skip Login
  Future<void> setSkipLogin(bool skip) async {
    _skipLogin = skip;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('skip_login', skip);
    notifyListeners();
  }

  void removeAddress(String address) {}

  void logout() {}
}

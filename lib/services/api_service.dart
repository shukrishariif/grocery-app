import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:5000/api';

  /// ✅ Get Token from Shared Preferences
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  /// ✅ Save Token and User Data
  Future<void> saveUserData(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', userData['token']);
    await prefs.setString('user_data', jsonEncode(userData));
  }

  /// ✅ Register User
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
    required String address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone': phone,
          'address': address,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await saveUserData(data);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      throw Exception('❌ Registration Error: $e');
    }
  }

  /// ✅ Login User
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.trim(),
          'password': password.trim(),
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await saveUserData(data);
        return data;
      } else {
        throw Exception(data['message'] ?? 'Invalid email or password');
      }
    } catch (e) {
      throw Exception('❌ Login Error: $e');
    }
  }

  /// ✅ Retrieve Saved User Data
  Future<Map<String, dynamic>?> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userDataString = prefs.getString('user_data');
    if (userDataString != null) {
      return jsonDecode(userDataString);
    }
    return null;
  }

  /// ✅ Get User Profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('⚠ Not authenticated');

      final response = await http.get(
        Uri.parse('$baseUrl/users/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(data));
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to get profile');
      }
    } catch (e) {
      throw Exception('❌ Profile Fetch Error: $e');
    }
  }

  /// ✅ Update Profile Image
  Future<Map<String, dynamic>> updateProfileImage(String imagePath) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('⚠ Not authenticated');

      var request = http.MultipartRequest(
        'PUT',
        Uri.parse('$baseUrl/users/profile/image'),
      );

      request.headers['Authorization'] = 'Bearer $token';
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imagePath,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(data));
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to update profile image');
      }
    } catch (e) {
      throw Exception('❌ Profile Image Update Error: $e');
    }
  }

  /// ✅ Update User Profile (Name, Phone, Address)
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? address,
  }) async {
    try {
      final token = await getToken();
      if (token == null) throw Exception('⚠ Not authenticated');

      final response = await http.put(
        Uri.parse('$baseUrl/users/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone': phone,
          'address': address,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', jsonEncode(data));
        return data;
      } else {
        throw Exception(data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      throw Exception('❌ Profile Update Error: $e');
    }
  }

  /// ✅ Logout User (Clear Token & Data)
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('user_data');
    } catch (e) {
      throw Exception('❌ Logout Error: $e');
    }
  }

  /// ✅ Check If User is Logged In
  Future<bool> isAuthenticated() async {
    final token = await getToken();
    return token != null;
  }
}

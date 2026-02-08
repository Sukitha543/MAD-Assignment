import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://timebridge.up.railway.app/api";

  //POST REQUEST
  static Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> data, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        // Try to parse error message, fallback to straight body if fails
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(errorBody['message'] ?? 'Unknown Error');
        } catch (_) {
          throw Exception(
            'Server Error: ${response.statusCode}\n${response.body}',
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  //GET REQUEST
  static Future<List<dynamic>> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        if (response.body.trim().startsWith('<')) {
          throw Exception(
            'Server returned HTML instead of JSON. You might need to log in again.',
          );
        }
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        return jsonResponse['data'];
      } else {
        // Try to parse error message
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(
            errorBody['message'] ??
                'Failed to load data: ${response.statusCode}',
          );
        } catch (_) {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  //GET REQUEST (Returns full response body)
  static Future<dynamic> getFull(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        if (response.body.trim().startsWith('<')) {
          throw Exception(
            'Server returned HTML instead of JSON. You might need to log in again.',
          );
        }
        return jsonDecode(response.body);
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(
            errorBody['message'] ??
                'Failed to load data: ${response.statusCode}',
          );
        } catch (_) {
          throw Exception('Failed to load data: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // DELETE REQUEST
  static Future<Map<String, dynamic>> delete(
    String endpoint, {
    String? token,
  }) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.delete(url, headers: headers);

      if (response.statusCode == 200 || response.statusCode == 204) {
        if (response.body.isEmpty) return {};
        return jsonDecode(response.body);
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(errorBody['message'] ?? 'Delete failed');
        } catch (_) {
          throw Exception('Delete failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // STRIPE CHECKOUT SESSION (POST)
  static Future<Map<String, dynamic>> createCheckoutSession({
    required String name,
    required String email,
    required String phone,
    required String address,
    required String city,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/checkout');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
    final body = jsonEncode({
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'city': city,
    });

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(errorBody['message'] ?? 'Checkout failed');
        } catch (_) {
          throw Exception('Checkout failed: ${response.statusCode}');
        }
      }
    } catch (e) {
      rethrow;
    }
  }

  // CONFIRM PAYMENT (GET)
  static Future<Map<String, dynamic>> confirmPayment({
    required String sessionId,
    required String token,
  }) async {
    final url = Uri.parse('$baseUrl/checkout/success?session_id=$sessionId');
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        try {
          final errorBody = jsonDecode(response.body);
          throw Exception(
            errorBody['message'] ?? 'Payment confirmation failed',
          );
        } catch (_) {
          throw Exception(
            'Payment confirmation failed: ${response.statusCode}',
          );
        }
      }
    } catch (e) {
      rethrow;
    }
  }
}

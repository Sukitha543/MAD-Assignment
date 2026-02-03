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

    print('POST Request to: $url'); // DEBUG
    print('Payload: ${jsonEncode(data)}'); // DEBUG

    try {
      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(data),
      );

      print('Response Status: ${response.statusCode}'); // DEBUG
      print('Response Body: ${response.body}'); // DEBUG

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
      print('API Post Error: $e'); // DEBUG
      rethrow;
    }
  }

  //GET REQUEST
  static Future<List<dynamic>> get(String endpoint, {String? token}) async {
    final url = Uri.parse('$baseUrl/$endpoint');

    print('Fetching from: $url'); // DEBUG

    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };

    try {
      final response = await http.get(url, headers: headers);
      print('Response Status: ${response.statusCode}'); // DEBUG
      print('Response Body: ${response.body}'); // DEBUG

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
      print('API Error: $e'); // DEBUG
      rethrow;
    }
  }
}

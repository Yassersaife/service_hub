// lib/core/network/api_client.dart
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'http://localhost:8000/api';

  static String? _token;

  static void setToken(String token) {
    _token = token;
  }

  static void clearToken() {
    _token = null;
  }

  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // GET request
  static Future<ApiResponse> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'لا يوجد اتصال بالإنترنت',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'حدث خطأ: ${e.toString()}',
        data: null,
      );
    }
  }

  // POST request
  static Future<ApiResponse> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'لا يوجد اتصال بالإنترنت',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'حدث خطأ: ${e.toString()}',
        data: null,
      );
    }
  }

  // PUT request
  static Future<ApiResponse> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
        body: json.encode(data),
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'لا يوجد اتصال بالإنترنت',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'حدث خطأ: ${e.toString()}',
        data: null,
      );
    }
  }

  // DELETE request
  static Future<ApiResponse> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl$endpoint'),
        headers: _headers,
      );

      return _handleResponse(response);
    } on SocketException {
      return ApiResponse(
        success: false,
        message: 'لا يوجد اتصال بالإنترنت',
        data: null,
      );
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'حدث خطأ: ${e.toString()}',
        data: null,
      );
    }
  }

  static ApiResponse _handleResponse(http.Response response) {
    try {
      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          message: jsonData['message'] ?? 'تم بنجاح',
          data: jsonData['data'],
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'حدث خطأ',
          data: jsonData['data'],
        );
      }
    } catch (e) {
      return ApiResponse(
        success: false,
        message: 'خطأ في معالجة البيانات',
        data: null,
      );
    }
  }
}

// كلاس الاستجابة
class ApiResponse {
  final bool success;
  final String message;
  final dynamic data;

  ApiResponse({
    required this.success,
    required this.message,
    this.data,
  });

  @override
  String toString() {
    return 'ApiResponse(success: $success, message: $message, data: $data)';
  }
}
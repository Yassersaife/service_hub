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

  static Map<String, String> get _multipartHeaders {
    final headers = {
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
      print('GET: $baseUrl$endpoint');
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
      print('POST: $baseUrl$endpoint');
      print('Data: $data');

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
      print('PUT: $baseUrl$endpoint');
      print('Data: $data');

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

  // PATCH request (لـ admin operations)
  static Future<ApiResponse> patch(String endpoint, Map<String, dynamic> data) async {
    try {
      print('PATCH: $baseUrl$endpoint');
      print('Data: $data');

      final response = await http.patch(
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
      print('DELETE: $baseUrl$endpoint');

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

  // POST request مع ملفات (Multipart)
  static Future<ApiResponse> postMultipart({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, File>? files,
    Map<String, List<File>>? fileArrays,
  }) async {
    try {
      print('POST Multipart: $baseUrl$endpoint');
      print('Fields: $fields');
      print('Files: ${files?.keys}');
      print('File Arrays: ${fileArrays?.keys}');

      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri);

      // إضافة headers
      request.headers.addAll(_multipartHeaders);

      // إضافة الحقول النصية
      request.fields.addAll(fields);

      // إضافة الملفات المفردة
      if (files != null) {
        for (final entry in files.entries) {
          if (entry.value.existsSync()) {
            final multipartFile = await http.MultipartFile.fromPath(
              entry.key,
              entry.value.path,
            );
            request.files.add(multipartFile);
          }
        }
      }

      // إضافة مصفوفات الملفات
      if (fileArrays != null) {
        for (final entry in fileArrays.entries) {
          for (final file in entry.value) {
            if (file.existsSync()) {
              final multipartFile = await http.MultipartFile.fromPath(
                entry.key,
                file.path,
              );
              request.files.add(multipartFile);
            }
          }
        }
      }

      print('Total files: ${request.files.length}');

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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

  // PUT request مع ملفات (Multipart)
  static Future<ApiResponse> putMultipart({
    required String endpoint,
    required Map<String, String> fields,
    Map<String, File>? files,
    Map<String, List<File>>? fileArrays,
  }) async {
    try {
      print('PUT Multipart: $baseUrl$endpoint');

      final uri = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', uri); // Laravel يستخدم POST مع _method=PUT

      // إضافة headers
      request.headers.addAll(_multipartHeaders);

      // إضافة method override لـ PUT
      fields['_method'] = 'PUT';

      // إضافة الحقول النصية
      request.fields.addAll(fields);

      // إضافة الملفات المفردة
      if (files != null) {
        for (final entry in files.entries) {
          if (entry.value.existsSync()) {
            final multipartFile = await http.MultipartFile.fromPath(
              entry.key,
              entry.value.path,
            );
            request.files.add(multipartFile);
          }
        }
      }

      // إضافة مصفوفات الملفات
      if (fileArrays != null) {
        for (final entry in fileArrays.entries) {
          for (final file in entry.value) {
            if (file.existsSync()) {
              final multipartFile = await http.MultipartFile.fromPath(
                entry.key,
                file.path,
              );
              request.files.add(multipartFile);
            }
          }
        }
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

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
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      final jsonData = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ApiResponse(
          success: true,
          message: jsonData['message'] ?? 'تم بنجاح',
          data: jsonData['data'],
        );
      } else if (response.statusCode == 422) {
        // Laravel validation errors
        String errorMessage = jsonData['message'] ?? 'خطأ في البيانات المرسلة';
        if (jsonData['errors'] != null) {
          final errors = jsonData['errors'] as Map<String, dynamic>;
          final firstError = errors.values.first;
          if (firstError is List && firstError.isNotEmpty) {
            errorMessage = firstError.first.toString();
          }
        }
        return ApiResponse(
          success: false,
          message: errorMessage,
          data: jsonData,
        );
      } else {
        return ApiResponse(
          success: false,
          message: jsonData['message'] ?? 'حدث خطأ',
          data: jsonData,
        );
      }
    } catch (e) {
      print('Error parsing response: $e');
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
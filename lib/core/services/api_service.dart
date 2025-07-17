import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final BaseURL = 'https://42a1a9094441.ngrok-free.app';

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body, {
    bool useToken = true,
  }) async {
    final String? _token = useToken ? await _getToken() : null;

    try {
      final response = await http.post(
        Uri.parse('$BaseURL/api/finance$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (useToken && _token != null && _token.isNotEmpty)
            'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(body),
      );

      final statusCode = response.statusCode;
      final responseBody = response.body;

      if (statusCode == 200 || statusCode == 201) {
        final decoded = jsonDecode(responseBody);
        if (decoded is! Map<String, dynamic>) {
          throw Exception("Format response salah: $decoded");
        }
        return decoded;
      } else {
        String errorMessage = 'Terjadi kesalahan ($statusCode)';
        try {
          final errorJson = jsonDecode(responseBody);
          if (errorJson is Map<String, dynamic>) {
            errorMessage =
                errorJson['message'] ?? errorJson['error'] ?? responseBody;
          } else {
            errorMessage = responseBody;
          }
        } catch (_) {
          errorMessage = responseBody;
        }
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Gagal mengirim data: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body, {
    bool useToken = true,
  }) async {
    final String? _token = useToken ? await _getToken() : null;
    try {
      final response = await http.put(
        Uri.parse('$BaseURL/api/finance$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (useToken && _token != null && _token.isNotEmpty)
            'Authorization': 'Bearer $_token',
        },
        body: jsonEncode(body),
      );

      final statusCode = response.statusCode;
      final responseBody = response.body;
      if (statusCode == 200 || statusCode == 201) {
        final decoded = jsonDecode(responseBody);
        return decoded;
      } else {
        final decoded = jsonDecode(responseBody);
        String errorMessage = decoded['message'] ?? 'Error unknown';
        throw Exception(errorMessage);
      }
    } catch (e) {
      throw Exception('Gagal mengirim data: ${e.toString()}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final _token = await _getToken();
    if (_token == null || _token.isEmpty) {
      throw Exception(
          'Token tidak ditemukan atau kosong. Silakan login ulang.');
    }

    try {
      final response = await http.get(
        Uri.parse('$BaseURL/api/finance$endpoint'),
        headers: {
          'Content-Type': 'application/json',
          if (_token.isNotEmpty) 'authorization': 'Bearer $_token',
        },
      );
      final decoded = jsonDecode(response.body);

      return {
        'code': response.statusCode,
        'message': decoded['message'],
        'data': decoded['data'],
      };
    } catch (e) {
      throw Exception('Error during GET request: $e');
    }
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final _token = await _getToken();

    if (_token == null || _token.isEmpty) {
      throw Exception(
          'Token tidak ditemukan atau kosong. Silakan login ulang.');
    }

    try {
      final response = await http
          .delete(Uri.parse('$BaseURL/api/finance$endpoint'), headers: {
        'Content-Type': 'application/json',
        if (_token.isNotEmpty) 'authorization': 'Bearer $_token',
      });

      final statusCode = response.statusCode;
      final responseBody = response.body;
      if (statusCode == 200 || statusCode == 201) {
        final decoded = jsonDecode(responseBody);
        return decoded;
      } else {
        final decoded = jsonDecode(responseBody);
        String errorMessage = decoded['message'];
        throw Exception(
            'Error delete: code $statusCode, message = $errorMessage');
      }
    } catch (e) {
      throw Exception('Error During delete: ${e.toString()}');
    }
  }
}

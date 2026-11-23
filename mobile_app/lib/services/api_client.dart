import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';

class ApiClient {
  final ApiConfig _config = ApiConfig();

  Future<dynamic> get(String endpoint) async {
    final uri = Uri.parse('${_config.baseUrl}$endpoint');
    final response = await http
        .get(uri, headers: _config.headers)
        .timeout(const Duration(seconds: 8));

    return _processResponse(response);
  }

  Future<dynamic> post(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('${_config.baseUrl}$endpoint');
    final response = await http
        .post(uri, headers: _config.headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 8));

    return _processResponse(response);
  }

  Future<dynamic> put(String endpoint, Map<String, dynamic> body) async {
    final uri = Uri.parse('${_config.baseUrl}$endpoint');
    final response = await http
        .put(uri, headers: _config.headers, body: jsonEncode(body))
        .timeout(const Duration(seconds: 8));

    return _processResponse(response);
  }

  Future<dynamic> delete(String endpoint) async {
    final uri = Uri.parse('${_config.baseUrl}$endpoint');
    final response = await http
        .delete(uri, headers: _config.headers)
        .timeout(const Duration(seconds: 8));

    return _processResponse(response);
  }

  dynamic _processResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(utf8.decode(response.bodyBytes));
    } else {
      throw Exception(
        'Server Error (${response.statusCode}): ${response.body}',
      );
    }
  }
}


import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final Map<String, String> defaultHeaders;
  final http.Client _httpClient;

  ApiClient({required this.baseUrl, Map<String, String>? defaultHeaders, http.Client? client})
      : defaultHeaders = defaultHeaders ?? {},
        _httpClient = client ?? http.Client();

  Future<Map<String, dynamic>> getJson(String path, {Map<String, String>? headers}) async {
    final uri = Uri.parse('$baseUrl$path');
    final merged = <String, String>{'Accept': 'application/json'};
    merged.addAll(defaultHeaders);
    if (headers != null) merged.addAll(headers);

    final res = await _httpClient.get(uri, headers: merged);
    if (res.statusCode >= 200 && res.statusCode < 300) {
      return jsonDecode(res.body) as Map<String, dynamic>;
    }
    throw ApiException('HTTP ${res.statusCode}: ${res.reasonPhrase}');
  }

  void dispose() {
    _httpClient.close();
  }
}

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => 'ApiException: $message';
}

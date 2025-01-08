import 'dart:convert';
import 'package:http/http.dart' as http;

class CkanApiService {
  static const String baseUrl = 'https://data.houstontx.gov/api/3';
  static const String crimeDatasetId = 'houston-police-department-incidents';
  
  // Optional: Add your API key if you have one
  static const String apiKey = '';  // Add your API key here if you have one

  Future<Map<String, dynamic>> _makeRequest(
    String action, {
    Map<String, String>? queryParams,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('$baseUrl/action/$action')
        .replace(queryParameters: queryParams);

    final headers = {
      'Content-Type': 'application/json',
      if (apiKey.isNotEmpty) 'Authorization': apiKey,
    };

    try {
      final response = body != null
          ? await http.post(uri, headers: headers, body: json.encode(body))
          : await http.get(uri, headers: headers);

      print('Request to: ${uri.toString()}');
      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          return responseData['result'];
        } else {
          throw Exception(responseData['error']?['message'] ?? 'API request failed');
        }
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('API Error: $e');
      rethrow;
    }
  }

  // List all datasets
  Future<List<String>> listDatasets() async {
    final result = await _makeRequest('package_list');
    return List<String>.from(result);
  }

  // Get dataset info
  Future<Map<String, dynamic>> getDatasetInfo(String datasetId) async {
    final result = await _makeRequest('package_show', queryParams: {'id': datasetId});
    return result;
  }

  // Search datasets
  Future<Map<String, dynamic>> searchDatasets({
    String? query,
    int rows = 10,
    int start = 0,
  }) async {
    final result = await _makeRequest('package_search', queryParams: {
      if (query != null) 'q': query,
      'rows': rows.toString(),
      'start': start.toString(),
    });
    return result;
  }

  // Search within a specific resource (dataset)
  Future<Map<String, dynamic>> searchResource({
    required String resourceId,
    String? query,
    int limit = 100,
    int offset = 0,
    String? sort = null,
  }) async {
    final result = await _makeRequest('datastore_search', queryParams: {
      'resource_id': resourceId,
      'limit': limit.toString(),
      'offset': offset.toString(),
      if (query != null) 'q': query,
      if (sort != null) 'sort': sort,
    });
    return result;
  }

  // Get resource info and structure
  Future<Map<String, dynamic>> getResourceInfo(String resourceId) async {
    final result = await _makeRequest('resource_show', queryParams: {
      'id': resourceId,
    });
    return result;
  }

  // SQL Query (for more complex queries)
  Future<Map<String, dynamic>> sqlQuery(String sql) async {
    final result = await _makeRequest('datastore_search_sql', queryParams: {
      'sql': sql,
    });
    return result;
  }
} 
import 'package:http/http.dart' as http;
import 'dart:convert';

class CrimeMapService {
  static const String zenRowsApiKey = 'e9079e00e41a382abf84579e5b3723ea1af089ad';
  static const String baseUrl = 'https://api.zenrows.com/v1/';
  static const String targetUrl = 'https://communitycrimemap.com/map';

  Future<String> fetchCrimeMapData() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl).replace(
          queryParameters: {
            'url': targetUrl,
            'apikey': zenRowsApiKey,
          },
        ),
        headers: {
          'Accept': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body;
      } else {
        throw Exception('Failed to load crime map data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching crime map data: $e');
      rethrow;
    }
  }

  // Method to parse specific crime data from the response
  Future<List<Map<String, dynamic>>> getCrimeData() async {
    final htmlContent = await fetchCrimeMapData();
    // Here we would parse the HTML content to extract crime data
    // This depends on the structure of the Community Crime Map page
    // We might need to use a HTML parser package
    return [];
  }
} 
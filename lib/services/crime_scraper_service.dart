import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart';

class CrimeScraperService {
  static const String zenRowsBaseUrl = 'https://api.zenrows.com/v1/';
  static const String targetUrl = 'https://communitycrimemap.com/map';
  static const String apiKey = 'e9079e00e41a382abf84579e5b3723ea1af089ad';

  Future<Map<String, dynamic>> scrapeCrimeData() async {
    try {
      // Build URL with parameters
      final uri = Uri.parse(zenRowsBaseUrl).replace(
        queryParameters: {
          'url': targetUrl,
          'apikey': apiKey,
          'js_render': 'true',
          'premium_proxy': 'true',
        },
      );

      print('Fetching from: $uri');
      
      final response = await http.get(uri);
      
      if (response.statusCode == 200) {
        print('Response received: ${response.body.substring(0, 200)}...'); // Debug print
        
        final document = parse(response.body);
        return _extractData(document);
      } else {
        print('Error status code: ${response.statusCode}');
        print('Error response: ${response.body}');
        throw Exception('Failed to load page: ${response.statusCode}');
      }
    } catch (e) {
      print('Error scraping data: $e');
      rethrow;
    }
  }

  Map<String, dynamic> _extractData(Document document) {
    final data = <String, dynamic>{
      'crimes': [],
      'categories': [],
    };

    try {
      // Find the grid section
      final gridSection = document.querySelector('section.grid');
      if (gridSection != null) {
        // Find all links with data-testid="link"
        final links = gridSection.querySelectorAll('a[data-testid="link"]');
        
        for (var link in links) {
          print('Found link: ${link.text}'); // Debug print
          data['categories'].add(link.text.trim());
        }
      }

      // Extract crime markers (adjust selectors based on actual HTML structure)
      final markers = document.querySelectorAll('.marker, .crime-point, [data-type="crime"]');
      for (var marker in markers) {
        final crime = {
          'type': marker.attributes['data-type'] ?? '',
          'location': marker.attributes['data-location'] ?? '',
          'date': marker.attributes['data-date'] ?? '',
          'latitude': marker.attributes['data-lat'] ?? '',
          'longitude': marker.attributes['data-lng'] ?? '',
          'description': marker.text.trim(),
        };
        data['crimes'].add(crime);
      }

      print('Extracted data: $data'); // Debug print
      return data;
    } catch (e) {
      print('Error extracting data: $e');
      return data; // Return empty data structure on error
    }
  }
} 
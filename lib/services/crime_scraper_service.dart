import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class CrimeScraperService {
  // Houston Police Department API endpoint
  static const String apiUrl = 'https://data.houstontx.gov/api/3/action/datastore_search';
  static const String resourceId = '36310599-c9bc-499a-af44-a8b874438e81'; // Police Incidents ID

  Future<List<Map<String, dynamic>>> getCrimeData() async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?resource_id=$resourceId&limit=100'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final records = data['result']['records'] as List;
          
          // Convert each record to a marker format
          return records.map((record) {
            return {
              'type': record['offense_type'] ?? '',
              'location': record['block_range'] ?? '',
              'date': record['occurred_date'] ?? '',
              'latitude': record['latitude']?.toString() ?? '',
              'longitude': record['longitude']?.toString() ?? '',
              'description': record['offense_type'] ?? '',
            };
          }).toList();
        }
      }
      throw Exception('Failed to load crime data');
    } catch (e) {
      print('Error getting crime data: $e');
      return [];
    }
  }

  // Optional: Add method to get specific crime types
  Future<List<Map<String, dynamic>>> getCrimesByType(String crimeType) async {
    try {
      final response = await http.get(
        Uri.parse('$apiUrl?resource_id=$resourceId&q=$crimeType'),
        headers: {
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final records = data['result']['records'] as List;
          return records.map((record) => record as Map<String, dynamic>).toList();
        }
      }
      return [];
    } catch (e) {
      print('Error getting crimes by type: $e');
      return [];
    }
  }
} 
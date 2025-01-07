import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/department.dart';

class HoustonApiService {
  // OData endpoint
  static const String odataUrl = 'https://data.houstontx.gov/datastore/odata3.0/36310599-c9bc-499a-af44-a8b874438e81';
  
  // CKAN API endpoint
  static const String ckanUrl = 'https://data.houstontx.gov/api/3/action/datastore_search';
  static const String resourceId = '36310599-c9bc-499a-af44-a8b874438e81';

  Future<List<Department>> getDepartments() async {
    try {
      // Using CKAN API for more flexible querying
      final response = await http.get(
        Uri.parse('$ckanUrl?resource_id=$resourceId&limit=100'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          final records = data['result']['records'] as List;
          return records.map((record) => Department.fromJson(record)).toList();
        }
      }
      throw Exception('Failed to load departments');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Optional: Add method to get department by ID
  Future<Department?> getDepartmentById(int departmentId) async {
    try {
      final response = await http.get(
        Uri.parse('$ckanUrl?resource_id=$resourceId&filters={"_1":"$departmentId"}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] && data['result']['records'].isNotEmpty) {
          return Department.fromJson(data['result']['records'][0]);
        }
      }
      return null;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
} 
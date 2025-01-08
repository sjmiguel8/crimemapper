import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/department.dart';

class DepartmentService {
  Future<List<Department>> loadDepartments() async {
    try {
      // Load CSV file from assets
      final data = await rootBundle.loadString('assets/houston_departments.csv');
      
      // Parse CSV
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);
      
      // First row is headers
      List<String> headers = csvTable[0].map((e) => e.toString()).toList();
      print('CSV Headers: $headers'); // Debug print
      
      // Convert rows to Department objects
      return csvTable.skip(1).map((row) {
        // Create a map of column names to values
        Map<String, dynamic> rowMap = {};
        for (var i = 0; i < headers.length; i++) {
          rowMap[headers[i]] = row[i];
        }
        return Department.fromCsv(rowMap);
      }).toList();
    } catch (e) {
      print('Error loading departments: $e');
      return [];
    }
  }

  // Add method to filter departments by type
  Future<List<Department>> getDepartmentsByType(String type) async {
    final departments = await loadDepartments();
    return departments.where((dept) => dept.type == type).toList();
  }

  // Add method to search departments
  Future<List<Department>> searchDepartments(String query) async {
    final departments = await loadDepartments();
    final lowercaseQuery = query.toLowerCase();
    return departments.where((dept) {
      return dept.name.toLowerCase().contains(lowercaseQuery) ||
             dept.abbreviation.toLowerCase().contains(lowercaseQuery) ||
             dept.type.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
} 
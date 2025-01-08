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
      print('CSV Headers: $headers');
      
      // Convert rows to Department objects
      List<Department> departments = [];
      
      // Skip header row and process each data row
      for (var i = 1; i < csvTable.length; i++) {
        try {
          final row = csvTable[i];
          if (row.length >= headers.length) {
            Map<String, dynamic> rowMap = {};
            for (var j = 0; j < headers.length; j++) {
              rowMap[headers[j]] = row[j]?.toString() ?? '';
            }
            
            final department = Department.fromCsv(rowMap);
            departments.add(department);
            print('Loaded department: ${department.name}');
          }
        } catch (e) {
          print('Error parsing row $i: $e');
        }
      }
      
      print('Successfully loaded ${departments.length} departments');
      return departments;
      
    } catch (e) {
      print('Error loading departments: $e');
      rethrow;
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
             dept.acronym.toLowerCase().contains(lowercaseQuery) ||
             dept.type.toLowerCase().contains(lowercaseQuery);
    }).toList();
  }
} 
import 'package:flutter/services.dart';
import 'package:csv/csv.dart';
import '../models/crime_report.dart';

class LocalDataService {
  Future<List<CrimeReport>> loadCrimeData() async {
    try {
      // Load CSV file from assets
      final data = await rootBundle.loadString('assets/houston_crime_data.csv');
      
      // Parse CSV
      List<List<dynamic>> csvTable = const CsvToListConverter().convert(data);
      
      // First row is headers
      List<String> headers = csvTable[0].map((e) => e.toString()).toList();
      
      // Convert rows to CrimeReport objects
      return csvTable.skip(1).map((row) {
        // Create a map of column names to values
        Map<String, dynamic> rowMap = {};
        for (var i = 0; i < headers.length; i++) {
          rowMap[headers[i]] = row[i];
        }
        return CrimeReport.fromCsv(rowMap);
      }).toList();
    } catch (e) {
      print('Error loading local data: $e');
      return [];
    }
  }
} 
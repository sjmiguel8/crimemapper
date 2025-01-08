import 'package:excel/excel.dart';
import 'package:flutter/services.dart';
import '../models/crime_report.dart';

class CrimeDataService {
  Future<List<CrimeReport>> loadCrimeData() async {
    try {
      // Load Excel file from assets
      final bytes = await rootBundle.load('assets/crimes_data_2024.xlsx');
      final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
      
      // Get the first sheet
      final sheet = excel.tables[excel.tables.keys.first];
      
      // Get headers (first row)
      final headers = sheet.rows[0].map((cell) => cell?.value.toString() ?? '').toList();
      print('Excel Headers: $headers'); // Debug print
      
      // Convert rows to CrimeReport objects (skip header row)
      return sheet.rows.skip(1).map((row) {
        // Create a map of column names to values
        Map<String, dynamic> rowMap = {};
        for (var i = 0; i < headers.length; i++) {
          rowMap[headers[i]] = row[i]?.value;
        }
        return CrimeReport.fromExcel(rowMap);
      }).toList();
    } catch (e) {
      print('Error loading crime data: $e');
      return [];
    }
  }
} 
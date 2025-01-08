import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/local_data_service.dart';
import '../models/crime_report.dart';

final localDataServiceProvider = Provider((ref) => LocalDataService());

final crimeReportsProvider = FutureProvider<List<CrimeReport>>((ref) async {
  final service = ref.read(localDataServiceProvider);
  return service.loadCrimeData();
}); 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/crime_scraper_service.dart';

final crimeServiceProvider = Provider((ref) => CrimeScraperService());

final crimeDataProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  final service = ref.read(crimeServiceProvider);
  return service.getCrimeData();
}); 
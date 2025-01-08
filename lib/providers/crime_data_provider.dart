import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/crime_scraper_service.dart';

final crimeScraperProvider = Provider((ref) => CrimeScraperService());

final crimeDataProvider = FutureProvider((ref) async {
  final scraper = ref.read(crimeScraperProvider);
  return scraper.scrapeCrimeData();
}); 
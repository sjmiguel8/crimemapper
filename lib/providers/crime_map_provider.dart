import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/crime_map_service.dart';

final crimeMapServiceProvider = Provider((ref) => CrimeMapService());

final crimeMapDataProvider = FutureProvider((ref) async {
  final service = ref.read(crimeMapServiceProvider);
  return service.getCrimeData();
}); 
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/houston_api_service.dart';
import '../models/department.dart';

final houstonApiServiceProvider = Provider((ref) => HoustonApiService());

final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final apiService = ref.read(houstonApiServiceProvider);
  return apiService.getDepartments();
}); 
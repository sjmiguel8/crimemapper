import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/houston_api_service.dart';
import '../models/department.dart';

final houstonApiServiceProvider = Provider((ref) => HoustonApiService());

// Search query state provider
final searchQueryProvider = StateProvider<String>((ref) => '');

// Filtered departments provider
final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final apiService = ref.read(houstonApiServiceProvider);
  final searchQuery = ref.watch(searchQueryProvider).toLowerCase();
  
  final departments = await apiService.getDepartments();
  
  if (searchQuery.isEmpty) {
    return departments;
  }
  
  return departments.where((dept) {
    return dept.name.toLowerCase().contains(searchQuery) ||
           dept.abbreviation.toLowerCase().contains(searchQuery) ||
           dept.category.toLowerCase().contains(searchQuery);
  }).toList();
}); 
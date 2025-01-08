import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/department_service.dart';
import '../models/department.dart';

final departmentServiceProvider = Provider((ref) => DepartmentService());

final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  final service = ref.read(departmentServiceProvider);
  return service.loadDepartments();
});

// Add search functionality
final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredDepartmentsProvider = FutureProvider<List<Department>>((ref) async {
  final departments = await ref.watch(departmentsProvider.future);
  final query = ref.watch(searchQueryProvider);
  
  if (query.isEmpty) return departments;
  
  final lowercaseQuery = query.toLowerCase();
  return departments.where((dept) {
    return dept.name.toLowerCase().contains(lowercaseQuery) ||
           dept.abbreviation.toLowerCase().contains(lowercaseQuery) ||
           dept.type.toLowerCase().contains(lowercaseQuery);
  }).toList();
}); 
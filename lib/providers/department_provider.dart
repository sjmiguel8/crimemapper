import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/department_service.dart';
import '../models/department.dart';

final departmentServiceProvider = Provider((ref) => DepartmentService());

// Store the current filter type
final departmentTypeFilterProvider = StateProvider<String?>((ref) => null);

// Store the search query
final searchQueryProvider = StateProvider<String>((ref) => '');

// Get all departments
final departmentsProvider = FutureProvider<List<Department>>((ref) async {
  try {
    final service = ref.read(departmentServiceProvider);
    final departments = await service.loadDepartments();
    print('Loaded ${departments.length} departments in provider');
    return departments;
  } catch (e) {
    print('Error in departments provider: $e');
    rethrow;
  }
});

// Get filtered departments based on search and type
final filteredDepartmentsProvider = FutureProvider<List<Department>>((ref) async {
  final departments = await ref.watch(departmentsProvider.future);
  final query = ref.watch(searchQueryProvider);
  final typeFilter = ref.watch(departmentTypeFilterProvider);
  
  return departments.where((dept) {
    // First apply type filter if selected
    if (typeFilter != null && dept.type != typeFilter) {
      return false;
    }
    
    // Then apply search filter if query exists
    if (query.isEmpty) return true;
    
    final lowercaseQuery = query.toLowerCase();
    return dept.name.toLowerCase().contains(lowercaseQuery) ||
           dept.acronym.toLowerCase().contains(lowercaseQuery) ||
           dept.type.toLowerCase().contains(lowercaseQuery);
  }).toList();
}); 
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/department_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departmentsAsync = ref.watch(departmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Houston Departments'),
      ),
      body: departmentsAsync.when(
        data: (departments) => ListView.builder(
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final department = departments[index];
            return Card(
              margin: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(department.name),
                subtitle: Text(department.description ?? 'No description available'),
                onTap: () {
                  // Navigate to detail view
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
} 
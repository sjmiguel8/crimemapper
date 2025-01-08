import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/department_provider.dart';
import '../models/department.dart';
import '../utils/url_launcher.dart';
import '../screens/map_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final departments = ref.watch(filteredDepartmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Houston Departments'),
        actions: [
          // Type Filter Button
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Filter by Type'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: const Text('All'),
                        onTap: () {
                          ref.read(departmentTypeFilterProvider.notifier).state = null;
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Public Safety'),
                        onTap: () {
                          ref.read(departmentTypeFilterProvider.notifier).state = 'Public Safety';
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Human & Cultural Services'),
                        onTap: () {
                          ref.read(departmentTypeFilterProvider.notifier).state = 'Human & Cultural Services';
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Development & Maintenance'),
                        onTap: () {
                          ref.read(departmentTypeFilterProvider.notifier).state = 'Development & Maintenance Services';
                          Navigator.pop(context);
                        },
                      ),
                      ListTile(
                        title: const Text('Administrative'),
                        onTap: () {
                          ref.read(departmentTypeFilterProvider.notifier).state = 'Administrative Services';
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          // Map Button
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MapScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SearchBar(
              hintText: 'Search departments...',
              onChanged: (value) {
                ref.read(searchQueryProvider.notifier).state = value;
              },
            ),
          ),
          // Departments List
          Expanded(
            child: departments.when(
              data: (depts) {
                if (depts.isEmpty) {
                  return const Center(
                    child: Text('No departments found'),
                  );
                }
                return ListView.builder(
                  itemCount: depts.length,
                  itemBuilder: (context, index) {
                    final dept = depts[index];
                    return DepartmentCard(department: dept);
                  },
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text('Error loading departments: $error'),
                    TextButton(
                      onPressed: () {
                        ref.refresh(departmentsProvider);
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DepartmentCard extends StatelessWidget {
  final Department department;

  const DepartmentCard({
    super.key,
    required this.department,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 8.0,
        vertical: 4.0,
      ),
      child: ExpansionTile(
        title: Text(department.name),
        subtitle: Text(department.type),
        leading: CircleAvatar(
          child: Text(department.acronym),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (department.phone != null)
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(department.phone!),
                    onTap: () => launchUrlString('tel:${department.phone}'),
                  ),
                if (department.email != null)
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(department.email!),
                    onTap: () => launchUrlString('mailto:${department.email}'),
                  ),
                if (department.webpage.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.link),
                    title: const Text('Website'),
                    onTap: () => launchUrlString(department.webpage),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
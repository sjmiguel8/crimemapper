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
          // Add Map Button
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
                child: Text('Error: $error'),
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
          child: Text(department.abbreviation),
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
                if (department.website.isNotEmpty)
                  ListTile(
                    leading: const Icon(Icons.language),
                    title: const Text('Visit Website'),
                    onTap: () => launchUrlString(department.website),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/department.dart';
import '../providers/department_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final mapController = MapController();
  static const double initialZoom = 12.0;
  
  final Map<String, LatLng> departmentLocations = {
    'HPD': const LatLng(29.7604, -95.3698), // Police Department
    'HFD': const LatLng(29.7520, -95.3573), // Fire Department
    'HHD': const LatLng(29.7543, -95.3657), // Health Department
    'HPW': const LatLng(29.7604, -95.3698), // Public Works
    'DON': const LatLng(29.7589, -95.3677), // Dept of Neighborhoods
    'MCD': const LatLng(29.7605, -95.3691), // Municipal Courts
  };

  Color getDepartmentColor(String type) {
    switch (type) {
      case 'Public Safety':
        return Colors.red;
      case 'Human & Cultural Services':
        return Colors.blue;
      case 'Development & Maintenance Services':
        return Colors.green;
      case 'Administrative Services':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final departments = ref.watch(departmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Department Locations'),
      ),
      body: departments.when(
        data: (depts) {
          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  initialCenter: const LatLng(29.7604, -95.3698),
                  initialZoom: initialZoom,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                  ),
                  MarkerLayer(
                    markers: depts.map((dept) {
                      final location = departmentLocations[dept.acronym] ?? 
                          const LatLng(29.7604, -95.3698);
                      
                      return Marker(
                        point: location,
                        width: 80,
                        height: 80,
                        child: GestureDetector(
                          onTap: () => _showDepartmentInfo(context, dept),
                          child: Icon(
                            _getDepartmentIcon(dept.type),
                            color: getDepartmentColor(dept.type),
                            size: 40,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              // Legend
              Positioned(
                bottom: 100,
                right: 16,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Department Types:', style: TextStyle(fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.red, size: 12),
                            const Text(' Public Safety'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.blue, size: 12),
                            const Text(' Human & Cultural'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.green, size: 12),
                            const Text(' Development'),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.circle, color: Colors.orange, size: 12),
                            const Text(' Administrative'),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
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
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'zoom_in',
            onPressed: () {
              final zoom = mapController.camera.zoom + 1;
              mapController.move(mapController.camera.center, zoom);
            },
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 8),
          FloatingActionButton(
            heroTag: 'zoom_out',
            onPressed: () {
              final zoom = mapController.camera.zoom - 1;
              mapController.move(mapController.camera.center, zoom);
            },
            child: const Icon(Icons.remove),
          ),
        ],
      ),
    );
  }

  IconData _getDepartmentIcon(String type) {
    switch (type) {
      case 'Public Safety':
        return Icons.local_police;
      case 'Human & Cultural Services':
        return Icons.people;
      case 'Development & Maintenance Services':
        return Icons.construction;
      case 'Administrative Services':
        return Icons.business;
      default:
        return Icons.location_on;
    }
  }

  Future<void> _showDepartmentInfo(BuildContext context, Department dept) async {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dept.name,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text('Type: ${dept.type}'),
            if (dept.phone.isNotEmpty) Text('Phone: ${dept.phone}'),
            if (dept.email.isNotEmpty) Text('Email: ${dept.email}'),
            if (dept.webpage.isNotEmpty)
              TextButton(
                onPressed: () async {
                  final url = Uri.parse(dept.webpage);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text('Visit Website'),
              ),
          ],
        ),
      ),
    );
  }
} 
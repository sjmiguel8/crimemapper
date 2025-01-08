import 'package:flutter/material.dart';

class LayerOptionsSheet extends StatefulWidget {
  const LayerOptionsSheet({super.key});

  @override
  State<LayerOptionsSheet> createState() => _LayerOptionsSheetState();
}

class _LayerOptionsSheetState extends State<LayerOptionsSheet> {
  bool showDepartments = true;
  bool showCrimes = false;
  String crimeTimeRange = 'week';

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Map Layers',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          SwitchListTile(
            title: const Text('Departments'),
            value: showDepartments,
            onChanged: (value) {
              setState(() => showDepartments = value);
            },
          ),
          SwitchListTile(
            title: const Text('Crime Data'),
            value: showCrimes,
            onChanged: (value) {
              setState(() => showCrimes = value);
            },
          ),
          if (showCrimes)
            DropdownButton<String>(
              value: crimeTimeRange,
              items: const [
                DropdownMenuItem(value: 'week', child: Text('Past Week')),
                DropdownMenuItem(value: 'month', child: Text('Past Month')),
                DropdownMenuItem(value: 'year', child: Text('Past Year')),
              ],
              onChanged: (value) {
                setState(() => crimeTimeRange = value!);
              },
            ),
        ],
      ),
    );
  }
} 
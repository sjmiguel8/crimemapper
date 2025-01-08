class CrimeReport {
  final String id;
  final String offense;
  final DateTime date;
  final String location;
  final double latitude;
  final double longitude;

  CrimeReport({
    required this.id,
    required this.offense,
    required this.date,
    required this.location,
    required this.latitude,
    required this.longitude,
  });

  factory CrimeReport.fromCsv(Map<String, dynamic> row) {
    return CrimeReport(
      id: row['incident_number']?.toString() ?? '',
      offense: row['offense_type']?.toString() ?? '',
      date: DateTime.tryParse(row['occurred_date']?.toString() ?? '') ?? DateTime.now(),
      location: row['block_range']?.toString() ?? '',
      latitude: double.tryParse(row['latitude']?.toString() ?? '0') ?? 0,
      longitude: double.tryParse(row['longitude']?.toString() ?? '0') ?? 0,
    );
  }

  @override
  String toString() {
    return 'CrimeReport(id: $id, offense: $offense, location: $location)';
  }
} 
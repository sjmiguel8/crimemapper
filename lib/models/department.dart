class Department {
  final String id;
  final String name;
  final String abbreviation;
  final String type;
  final String website;
  final String? phone;
  final String? email;

  Department({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.type,
    required this.website,
    this.phone,
    this.email,
  });

  factory Department.fromCsv(Map<String, dynamic> row) {
    return Department(
      id: row['ID']?.toString() ?? '',
      name: row['Department Name']?.toString() ?? '',
      abbreviation: row['Acronym']?.toString() ?? '',
      type: row['Type']?.toString() ?? '',
      website: row['Webpage']?.toString() ?? '',
      phone: row['Phone']?.toString(),
      email: row['Email']?.toString(),
    );
  }

  @override
  String toString() {
    return 'Department(name: $name, abbreviation: $abbreviation, type: $type)';
  }
} 
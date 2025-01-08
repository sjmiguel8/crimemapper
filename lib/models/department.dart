class Department {
  final String id;
  final String name;
  final String type;
  final String acronym;
  final String webpage;
  final String phone;
  final String email;

  Department({
    required this.id,
    required this.name,
    required this.type,
    required this.acronym,
    required this.webpage,
    required this.phone,
    required this.email,
  });

  factory Department.fromCsv(Map<String, dynamic> map) {
    return Department(
      id: map['ID']?.toString() ?? '',
      name: map['Department Name'] ?? '',
      type: map['Type'] ?? '',
      acronym: map['Acronym'] ?? '',
      webpage: map['Webpage'] ?? '',
      phone: map['Phone']?.toString() ?? '',
      email: map['Email'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Department(id: $id, name: $name, type: $type, acronym: $acronym)';
  }
} 
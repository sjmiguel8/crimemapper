class Department {
  final String name;
  final String abbreviation;
  final String category;
  final String website;
  final String? phone;
  final String? email;
  final int departmentId;

  Department({
    required this.name,
    required this.abbreviation,
    required this.category,
    required this.website,
    this.phone,
    this.email,
    required this.departmentId,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['_3'] ?? '', // Full name
      abbreviation: json['_4'] ?? '', // Abbreviation like HPD, DON
      category: json['_2'] ?? '', // Category like Public Safety
      website: json['_5'] ?? '', // Website URL
      phone: json['_6'], // Phone number if available
      email: json['_7'], // Email if available
      departmentId: int.tryParse(json['_1'] ?? '0') ?? 0, // Department ID
    );
  }
} 
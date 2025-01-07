class Department {
  final String name;
  final String? description;
  final String? location;
  // Add other fields as needed

  Department({
    required this.name,
    this.description,
    this.location,
  });

  factory Department.fromJson(Map<String, dynamic> json) {
    return Department(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
    );
  }
} 
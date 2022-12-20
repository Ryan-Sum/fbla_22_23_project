class Teacher {
  final String name;
  final String id;

  Teacher({
    required this.name,
    required this.id,
  });

  static Teacher fromJson(Map<String, dynamic> json) => Teacher(
        name: json['name'],
        id: json['id'],
      );
}

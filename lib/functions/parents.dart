class Parent {
  final String name;
  final String id;
  final String studentId;

  Parent({
    required this.name,
    required this.id,
    required this.studentId,
  });

  static Parent fromJson(Map<String, dynamic> json) => Parent(
        name: json['name'],
        id: json['id'],
        studentId: json['studentId'],
      );
}

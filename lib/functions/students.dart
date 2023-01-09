class Student {
  final String name;
  final String id;
  final List<dynamic> classes;
  final List<dynamic> parents;

  Student({
    required this.name,
    required this.id,
    required this.classes,
    required this.parents,
  });

  static Student fromJson(Map<String, dynamic> json) => Student(
        name: json['name'],
        id: json['id'],
        classes: json['classes'],
        parents: json['parents'],
      );
}

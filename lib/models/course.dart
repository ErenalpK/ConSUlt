class Course {
  final String id;
  final String code;
  final String name;
  final String faculty;
  final String department;
  final String description;
  final int ects;
  final String instructor;
  final List<dynamic> prerequisites;
  final List<dynamic> corequisites;

  Course({
    required this.id,
    required this.code,
    required this.name,
    required this.faculty,
    required this.department,
    required this.description,
    required this.ects,
    required this.instructor,
    required this.prerequisites,
    required this.corequisites,
  });

  factory Course.fromFirestore(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      code: data['code'] ?? data['courseId'] ?? id,
      name: data['name'] ?? data['courseName'] ?? '',
      faculty: data['faculty'] ?? '',
      department: data['department'] ?? '',
      description: data['description'] ?? '',
      ects: data['ects'] ?? 0,
      instructor: data['instructor'] ?? '',
      prerequisites: data['prerequisites'] ?? [],
      corequisites: data['corequisites'] ?? [],
    );
  }
}

class Course {
  final String id;
  final String courseId;
  final String courseName;
  final String faculty;
  final String department;
  final String description;
  final int ects;
  final String instructor;

  Course({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.faculty,
    required this.department,
    required this.description,
    required this.ects,
    required this.instructor,
  });

  factory Course.fromFirestore(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      courseId: data['courseId'],
      courseName: data['courseName'],
      faculty: data['faculty'],
      department: data['department'],
      description: data['description'],
      ects: data['ects'],
      instructor: data['instructor'],
    );
  }
}

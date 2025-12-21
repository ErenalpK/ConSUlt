

class Comment {
  final String studentName;
  final String date;
  final String text;

  Comment({
    required this.studentName,
    required this.date,
    required this.text,
  });
}

class CourseDetail {
  final String faculty;
  final String code;
  final String name;
  final int commentCount;
  final String description;
  final String instructor;
  final double ects;
  final String prerequisites;
  final String corequisites;
  final List<Comment> comments;

  CourseDetail({
    required this.faculty,
    required this.code,
    required this.name,
    required this.commentCount,
    required this.description,
    required this.instructor,
    required this.ects,
    required this.prerequisites,
    required this.corequisites,
    required this.comments,
  });
}
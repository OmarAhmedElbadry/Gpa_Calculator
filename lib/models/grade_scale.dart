import 'dart:convert';
import 'grade.dart';

class GradeScale {
  final String name;
  final List<Grade> grades;

  GradeScale({
    required this.name,
    required this.grades,
  });

  factory GradeScale.standard() {
    return GradeScale(
      name: 'Standard 4.0',
      grades: [
        Grade(letter: 'A+', value: 4.0),
        Grade(letter: 'A', value: 4.0),
        Grade(letter: 'A-', value: 3.7),
        Grade(letter: 'B+', value: 3.3),
        Grade(letter: 'B', value: 3.0),
        Grade(letter: 'B-', value: 2.7),
        Grade(letter: 'C+', value: 2.3),
        Grade(letter: 'C', value: 2.0),
        Grade(letter: 'C-', value: 1.7),
        Grade(letter: 'D+', value: 1.3),
        Grade(letter: 'D', value: 1.0),
        Grade(letter: 'F', value: 0.0),
      ],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'grades': grades.map((g) => g.toMap()).toList(),
    };
  }

  factory GradeScale.fromMap(Map<String, dynamic> map) {
    return GradeScale(
      name: map['name'],
      grades: List<Grade>.from(
        map['grades']?.map((x) => Grade.fromMap(x)),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory GradeScale.fromJson(String source) => 
      GradeScale.fromMap(json.decode(source));

  GradeScale copyWith({
    String? name,
    List<Grade>? grades,
  }) {
    return GradeScale(
      name: name ?? this.name,
      grades: grades ?? this.grades,
    );
  }

  Grade? getGradeByLetter(String letter) {
    try {
      return grades.firstWhere((g) => g.letter == letter);
    } catch (e) {
      return null;
    }
  }

  double getGradeValue(String letter) {
    final grade = getGradeByLetter(letter);
    return grade?.value ?? 0.0;
  }
}

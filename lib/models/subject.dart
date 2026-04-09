import 'dart:convert';

class Subject {
  final String id;
  final String name;
  final int credits;
  final String grade;

  Subject({
    required this.id,
    required this.name,
    required this.credits,
    required this.grade,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'credits': credits,
      'grade': grade,
    };
  }

  factory Subject.fromMap(Map<String, dynamic> map) {
    return Subject(
      id: map['id'],
      name: map['name'],
      credits: map['credits'],
      grade: map['grade'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Subject.fromJson(String source) => 
      Subject.fromMap(json.decode(source));

  Subject copyWith({
    String? id,
    String? name,
    int? credits,
    String? grade,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      credits: credits ?? this.credits,
      grade: grade ?? this.grade,
    );
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'subject.dart';

class Semester {
  final String id;
  final String name;
  final List<Subject> subjects;
  final bool isInProgress;
  final int? colorValue; // Stored as int for serialization

  Semester({
    required this.id,
    required this.name,
    required this.subjects,
    this.isInProgress = false,
    this.colorValue,
  });

  Color? get color => colorValue != null ? Color(colorValue!) : null;

  int get totalCredits {
    return subjects.fold(0, (sum, subject) => sum + subject.credits);
  }

  double calculateGPA(Map<String, double> gradeScale) {
    if (subjects.isEmpty) return 0.0;
    
    double totalPoints = 0.0;
    int totalCredits = 0;

    for (var subject in subjects) {
      final gradeValue = gradeScale[subject.grade] ?? 0.0;
      totalPoints += gradeValue * subject.credits;
      totalCredits += subject.credits;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'subjects': subjects.map((s) => s.toMap()).toList(),
      'isInProgress': isInProgress,
      'colorValue': colorValue,
    };
  }

  factory Semester.fromMap(Map<String, dynamic> map) {
    return Semester(
      id: map['id'],
      name: map['name'],
      subjects: List<Subject>.from(
        map['subjects']?.map((x) => Subject.fromMap(x)),
      ),
      isInProgress: map['isInProgress'] ?? false,
      colorValue: map['colorValue'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Semester.fromJson(String source) => 
      Semester.fromMap(json.decode(source));

  Semester copyWith({
    String? id,
    String? name,
    List<Subject>? subjects,
    bool? isInProgress,
    int? colorValue,
  }) {
    return Semester(
      id: id ?? this.id,
      name: name ?? this.name,
      subjects: subjects ?? this.subjects,
      isInProgress: isInProgress ?? this.isInProgress,
      colorValue: colorValue ?? this.colorValue,
    );
  }
}

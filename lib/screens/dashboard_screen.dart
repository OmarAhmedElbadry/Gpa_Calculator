import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../models/grade_scale.dart';
import '../widgets/gpa_circle.dart';
import '../widgets/stats_card.dart';
import '../widgets/target_progress_card.dart';
import '../widgets/what_if_simulator.dart';

class DashboardScreen extends StatelessWidget {
  final List<Semester> semesters;
  final double targetGPA;
  final GradeScale gradeScale;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const DashboardScreen({
    super.key,
    required this.semesters,
    required this.targetGPA,
    required this.gradeScale,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  double _calculateOverallGPA() {
    if (semesters.isEmpty) return 0.0;

    final completedSemesters = semesters.where((s) => !s.isInProgress).toList();
    if (completedSemesters.isEmpty) return 0.0;

    final gradeMap = {
      for (var grade in gradeScale.grades) grade.letter: grade.value
    };

    double totalPoints = 0.0;
    int totalCredits = 0;

    for (var semester in completedSemesters) {
      for (var subject in semester.subjects) {
        final gradeValue = gradeMap[subject.grade] ?? 0.0;
        totalPoints += gradeValue * subject.credits;
        totalCredits += subject.credits;
      }
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  int _getTotalCredits() {
    final completedSemesters = semesters.where((s) => !s.isInProgress).toList();
    return completedSemesters.fold(
      0,
      (sum, semester) => sum + semester.totalCredits,
    );
  }

  int _getCompletedSemesters() {
    return semesters.where((s) => !s.isInProgress).length;
  }

  double _getBestGPA() {
    if (semesters.isEmpty) return 0.0;

    final completedSemesters = semesters.where((s) => !s.isInProgress).toList();
    if (completedSemesters.isEmpty) return 0.0;

    final gradeMap = {
      for (var grade in gradeScale.grades) grade.letter: grade.value
    };

    double bestGPA = 0.0;
    for (var semester in completedSemesters) {
      final gpa = semester.calculateGPA(gradeMap);
      if (gpa > bestGPA) {
        bestGPA = gpa;
      }
    }

    return bestGPA;
  }

  @override
  Widget build(BuildContext context) {
    final currentGPA = _calculateOverallGPA();
    final totalCredits = _getTotalCredits();
    final completedSemesters = _getCompletedSemesters();
    final bestGPA = _getBestGPA();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Your GPA',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: onThemeToggle,
                    icon: Icon(
                      isDarkMode
                          ? Icons.light_mode_outlined
                          : Icons.dark_mode_outlined,
                      size: 28,
                    ),
                    style: IconButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              GPACircle(gpa: currentGPA),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: StatsCard(
                      icon: Icons.menu_book_outlined,
                      label: 'Credits',
                      value: totalCredits.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      icon: Icons.access_time_outlined,
                      label: 'Semesters',
                      value: completedSemesters.toString(),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatsCard(
                      icon: Icons.emoji_events_outlined,
                      label: 'Best',
                      value: bestGPA.toStringAsFixed(1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TargetProgressCard(
                currentGPA: currentGPA,
                targetGPA: targetGPA,
              ),
              const SizedBox(height: 24),
              WhatIfSimulator(
                semesters: semesters,
                currentGPA: currentGPA,
                gradeScale: gradeScale,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

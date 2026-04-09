import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../models/grade_scale.dart';

class WhatIfSimulator extends StatefulWidget {
  final List<Semester> semesters;
  final double currentGPA;
  final GradeScale gradeScale;

  const WhatIfSimulator({
    super.key,
    required this.semesters,
    required this.currentGPA,
    required this.gradeScale,
  });

  @override
  State<WhatIfSimulator> createState() => _WhatIfSimulatorState();
}

class _WhatIfSimulatorState extends State<WhatIfSimulator> {
  final Map<String, String> _simulatedGrades = {};
  bool _isExpanded = false;

  Semester? get _currentSemester {
    try {
      return widget.semesters.firstWhere((s) => s.isInProgress);
    } catch (e) {
      return null;
    }
  }

  double _calculateSimulatedGPA() {
    final currentSemester = _currentSemester;
    if (currentSemester == null) return widget.currentGPA;

    final completedSemesters = widget.semesters.where((s) => !s.isInProgress).toList();
    
    final gradeMap = {
      for (var grade in widget.gradeScale.grades) grade.letter: grade.value
    };

    // Calculate points from completed semesters
    double totalPoints = 0.0;
    int totalCredits = 0;

    for (var semester in completedSemesters) {
      for (var subject in semester.subjects) {
        final gradeValue = gradeMap[subject.grade] ?? 0.0;
        totalPoints += gradeValue * subject.credits;
        totalCredits += subject.credits;
      }
    }

    // Add simulated grades from current semester
    for (var subject in currentSemester.subjects) {
      final simulatedGrade = _simulatedGrades[subject.id] ?? subject.grade;
      final gradeValue = gradeMap[simulatedGrade] ?? 0.0;
      totalPoints += gradeValue * subject.credits;
      totalCredits += subject.credits;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final currentSemester = _currentSemester;
    
    if (currentSemester == null) {
      return const SizedBox.shrink();
    }

    final simulatedGPA = _calculateSimulatedGPA();
    final difference = simulatedGPA - widget.currentGPA;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(
                    Icons.science_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'What-If Simulator',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        simulatedGPA.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      if (difference != 0)
                        Text(
                          '${difference > 0 ? '+' : ''}${difference.toStringAsFixed(2)} from current',
                          style: TextStyle(
                            fontSize: 10,
                            color: difference > 0
                                ? const Color(0xFF10B981)
                                : Colors.red,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    _isExpanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: currentSemester.subjects.map((subject) {
                  final currentGrade = _simulatedGrades[subject.id] ?? subject.grade;
                  
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? const Color(0xFF1E293B)
                          : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                subject.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                currentGrade,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Theme.of(context).colorScheme.primary,
                            inactiveTrackColor: Colors.grey.shade400,
                            thumbColor: Theme.of(context).colorScheme.primary,
                            overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                            trackHeight: 4,
                            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                          ),
                          child: Slider(
                            value: widget.gradeScale.grades.indexWhere(
                              (g) => g.letter == currentGrade,
                            ).toDouble(),
                            min: 0,
                            max: (widget.gradeScale.grades.length - 1).toDouble(),
                            divisions: widget.gradeScale.grades.length - 1,
                            onChanged: (value) {
                              setState(() {
                                _simulatedGrades[subject.id] = 
                                    widget.gradeScale.grades[value.toInt()].letter;
                              });
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.gradeScale.grades.last.letter,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              widget.gradeScale.grades.first.letter,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

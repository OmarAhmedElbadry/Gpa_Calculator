import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../models/grade_scale.dart';

class PlannerScreen extends StatefulWidget {
  final List<Semester> semesters;
  final double targetGPA;
  final GradeScale gradeScale;
  final Function(double) onTargetGPAChanged;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const PlannerScreen({
    super.key,
    required this.semesters,
    required this.targetGPA,
    required this.gradeScale,
    required this.onTargetGPAChanged,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<PlannerScreen> createState() => _PlannerScreenState();
}

class _PlannerScreenState extends State<PlannerScreen> {
  late double _targetGPA;
  int _nextSemesterCredits = 15;

  @override
  void initState() {
    super.initState();
    _targetGPA = widget.targetGPA;
  }

  double _calculateCurrentGPA() {
    if (widget.semesters.isEmpty) return 0.0;

    final completedSemesters = widget.semesters.where((s) => !s.isInProgress).toList();
    if (completedSemesters.isEmpty) return 0.0;

    final gradeMap = {
      for (var grade in widget.gradeScale.grades) grade.letter: grade.value
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
    final completedSemesters = widget.semesters.where((s) => !s.isInProgress).toList();
    return completedSemesters.fold(
      0,
      (sum, semester) => sum + semester.totalCredits,
    );
  }

  double _calculateRequiredGPA() {
    final currentGPA = _calculateCurrentGPA();
    final currentCredits = _getTotalCredits();

    if (currentCredits == 0) return _targetGPA;

    final requiredPoints = (_targetGPA * (currentCredits + _nextSemesterCredits)) -
        (currentGPA * currentCredits);

    final requiredGPA = requiredPoints / _nextSemesterCredits;
    return requiredGPA.clamp(0.0, 4.0);
  }

  String _getEncouragingMessage(double requiredGPA) {
    if (requiredGPA <= 2.0) {
      return 'This is very achievable! Keep up the great work.';
    } else if (requiredGPA <= 3.0) {
      return 'This is achievable with good effort!';
    } else if (requiredGPA <= 3.5) {
      return 'This will require strong performance.';
    } else if (requiredGPA <= 4.0) {
      return 'This is challenging but possible!';
    } else {
      return 'This target requires exceptional performance.';
    }
  }

  List<Map<String, dynamic>> _suggestGradeDistribution() {
    final requiredGPA = _calculateRequiredGPA();
    
    // Simple distribution: assume 3-credit courses
    final numCourses = (_nextSemesterCredits / 3).ceil();
    final creditsPerCourse = 3;
    
    final grades = widget.gradeScale.grades.where((g) => g.value > 0).toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    List<Map<String, dynamic>> distribution = [];
    
    if (requiredGPA <= 4.0) {
      // Try to distribute grades to achieve the required GPA
      int remainingCourses = numCourses;
      double remainingPoints = requiredGPA * _nextSemesterCredits;
      
      for (int i = 0; i < numCourses && remainingCourses > 0; i++) {
        double targetPerCourse = remainingPoints / remainingCourses;
        
        // Find closest grade
        var closestGrade = grades.first;
        double minDiff = (grades.first.value - targetPerCourse).abs();
        
        for (var grade in grades) {
          double diff = (grade.value - targetPerCourse).abs();
          if (diff < minDiff) {
            minDiff = diff;
            closestGrade = grade;
          }
        }
        
        distribution.add({
          'name': 'Subject ${i + 1}',
          'credits': creditsPerCourse,
          'grade': closestGrade.letter,
          'value': closestGrade.value,
        });
        
        remainingPoints -= closestGrade.value * creditsPerCourse;
        remainingCourses--;
      }
    } else {
      // If required GPA is > 4.0, suggest all A+ grades
      for (int i = 0; i < numCourses; i++) {
        distribution.add({
          'name': 'Subject ${i + 1}',
          'credits': creditsPerCourse,
          'grade': grades.first.letter,
          'value': grades.first.value,
        });
      }
    }
    
    return distribution;
  }

  @override
  Widget build(BuildContext context) {
    final currentGPA = _calculateCurrentGPA();
    final currentCredits = _getTotalCredits();
    final requiredGPA = _calculateRequiredGPA();
    final distribution = _suggestGradeDistribution();

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.track_changes,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Target Planner'),
            Text(
              'Plan your path to success',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: widget.onThemeToggle,
            icon: Icon(
              widget.isDarkMode
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target GPA Slider
            Container(
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'Target GPA',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: Colors.grey.shade600,
                          ),
                        ],
                      ),
                      Text(
                        _targetGPA.toStringAsFixed(2),
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      inactiveTrackColor: Colors.grey.shade300,
                      thumbColor: Theme.of(context).colorScheme.primary,
                      overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                      trackHeight: 8,
                      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
                    ),
                    child: Slider(
                      value: _targetGPA,
                      min: 0.0,
                      max: 4.0,
                      divisions: 40,
                      onChanged: (value) {
                        setState(() {
                          _targetGPA = value;
                        });
                        widget.onTargetGPAChanged(value);
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '0.00',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      Text(
                        '4.00',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Current Stats
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current GPA',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentGPA.toStringAsFixed(2),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Credits Completed',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentCredits.toString(),
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Next Semester Credits Selector
            Container(
              padding: const EdgeInsets.all(20),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Next Semester Credits',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  DropdownButton<int>(
                    value: _nextSemesterCredits,
                    underline: Container(),
                    items: [9, 12, 15, 18, 21].map((credits) {
                      return DropdownMenuItem(
                        value: credits,
                        child: Text(
                          '$credits credits',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _nextSemesterCredits = value!;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Required GPA
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: requiredGPA <= 4.0
                    ? const Color(0xFF10B981).withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: requiredGPA <= 4.0
                      ? const Color(0xFF10B981)
                      : Colors.orange,
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calculate_outlined,
                        color: requiredGPA <= 4.0
                            ? const Color(0xFF10B981)
                            : Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Required Next Semester GPA',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    requiredGPA.toStringAsFixed(2),
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: requiredGPA <= 4.0
                          ? const Color(0xFF10B981)
                          : Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _getEncouragingMessage(requiredGPA),
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Suggested Grade Distribution
            Container(
              padding: const EdgeInsets.all(20),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Suggested Grade Distribution',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  ...distribution.map((item) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? const Color(0xFF1E293B)
                              : Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  '${item['credits']} credits',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                item['grade'],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

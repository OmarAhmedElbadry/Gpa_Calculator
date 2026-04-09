import 'package:flutter/material.dart';
import '../models/semester.dart';
import '../models/subject.dart';
import '../models/grade_scale.dart';

class SemestersScreen extends StatefulWidget {
  final List<Semester> semesters;
  final GradeScale gradeScale;
  final Function(List<Semester>) onSemestersChanged;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const SemestersScreen({
    super.key,
    required this.semesters,
    required this.gradeScale,
    required this.onSemestersChanged,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<SemestersScreen> createState() => _SemestersScreenState();
}

class _SemestersScreenState extends State<SemestersScreen> {
  // Simple ID generator using timestamp
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  void _addSemester() {
    final newSemester = Semester(
      id: _generateId(),
      name: 'New Semester',
      subjects: [],
      isInProgress: false,
    );

    final updatedSemesters = [...widget.semesters, newSemester];
    widget.onSemestersChanged(updatedSemesters);

    _editSemester(updatedSemesters.length - 1, semester: newSemester);
  }

  void _deleteSemester(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Semester'),
        content: const Text('Are you sure you want to delete this semester?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final updatedSemesters = [...widget.semesters];
              updatedSemesters.removeAt(index);
              widget.onSemestersChanged(updatedSemesters);
              Navigator.pop(context);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _editSemester(int index, {Semester? semester}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SemesterDetailScreen(
          semester: semester ?? widget.semesters[index],
          gradeScale: widget.gradeScale,
          onSemesterChanged: (updatedSemester) {
            final updatedSemesters = [...widget.semesters];
            updatedSemesters[index] = updatedSemester;
            widget.onSemestersChanged(updatedSemesters);
          },
          onDelete: () => _deleteSemester(index),
        ),
      ),
    );
  }

  double _calculateSemesterGPA(Semester semester) {
    final gradeMap = {
      for (var grade in widget.gradeScale.grades) grade.letter: grade.value
    };
    return semester.calculateGPA(gradeMap);
  }

  @override
  Widget build(BuildContext context) {
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
              Icons.menu_book,
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Semesters'),
            Text(
              '${widget.semesters.length} total',
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: InkWell(
              onTap: _addSemester,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Add Semester',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: widget.semesters.length,
              itemBuilder: (context, index) {
                final semester = widget.semesters[index];
                final gpa = _calculateSemesterGPA(semester);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: InkWell(
                    onTap: () => _editSemester(index),
                    onLongPress: () => _deleteSemester(index),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
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
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: semester.color ?? Theme.of(context).colorScheme.primary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.school_outlined,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  semester.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${semester.subjects.length} subjects • ${semester.totalCredits} credits',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          semester.isInProgress
                              ? Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'In Progress',
                                    style: TextStyle(
                                      color: Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    gpa.toStringAsFixed(2),
                                    style: const TextStyle(
                                      color: Color(0xFF10B981),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                          const SizedBox(width: 8),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SemesterDetailScreen extends StatefulWidget {
  final Semester semester;
  final GradeScale gradeScale;
  final Function(Semester) onSemesterChanged;
  final VoidCallback onDelete;

  const SemesterDetailScreen({
    super.key,
    required this.semester,
    required this.gradeScale,
    required this.onSemesterChanged,
    required this.onDelete,
  });

  @override
  State<SemesterDetailScreen> createState() => _SemesterDetailScreenState();
}

class _SemesterDetailScreenState extends State<SemesterDetailScreen> {
  late Semester _semester;
  final _nameController = TextEditingController();

  // Simple ID generator
  String _generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void initState() {
    super.initState();
    _semester = widget.semester;
    _nameController.text = _semester.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateSemester() {
    widget.onSemesterChanged(_semester);
  }

  void _addSubject() {
    final newSubject = Subject(
      id: _generateId(),
      name: 'New Subject',
      credits: 3,
      grade: 'A',
    );

    setState(() {
      _semester = _semester.copyWith(
        subjects: [..._semester.subjects, newSubject],
      );
    });
    _updateSemester();
  }

  void _deleteSubject(int index) {
    setState(() {
      final updatedSubjects = [..._semester.subjects];
      updatedSubjects.removeAt(index);
      _semester = _semester.copyWith(subjects: updatedSubjects);
    });
    _updateSemester();
  }

  void _updateSubject(int index, Subject updatedSubject) {
    setState(() {
      final updatedSubjects = [..._semester.subjects];
      updatedSubjects[index] = updatedSubject;
      _semester = _semester.copyWith(subjects: updatedSubjects);
    });
    _updateSemester();
  }

  double _calculateGPA() {
    final gradeMap = {
      for (var grade in widget.gradeScale.grades) grade.letter: grade.value
    };
    return _semester.calculateGPA(gradeMap);
  }

  @override
  Widget build(BuildContext context) {
    final gpa = _calculateGPA();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _nameController,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Semester Name',
          ),
          onChanged: (value) {
            setState(() {
              _semester = _semester.copyWith(name: value);
            });
            _updateSemester();
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'GPA: ${gpa.toStringAsFixed(2)}',
              style: const TextStyle(
                color: Color(0xFF10B981),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Color Picker
            Container(
              margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              padding: const EdgeInsets.all(16),
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
                        Icons.color_lens_outlined,
                        size: 20,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Semester Color',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // Preset colors
                      Colors.red,
                      Colors.pink,
                      Colors.purple,
                      Colors.deepPurple,
                      Colors.indigo,
                      Colors.blue,
                      Colors.lightBlue,
                      Colors.cyan,
                      Colors.teal,
                      Colors.green,
                      Colors.lightGreen,
                      Colors.lime,
                      Colors.yellow,
                      Colors.amber,
                      Colors.orange,
                      Colors.deepOrange,
                      Colors.brown,
                      Colors.blueGrey,
                      Colors.grey,
                      Colors.black,
                    ].map((color) {
                      final isSelected = _semester.colorValue == color.value;
                      return InkWell(
                        onTap: () {
                          setState(() {
                            _semester = _semester.copyWith(
                              colorValue: isSelected ? null : color.value,
                            );
                          });
                          _updateSemester();
                        },
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(
                                    color: Theme.of(context).colorScheme.primary,
                                    width: 3,
                                  )
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: isSelected
                              ? const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 20,
                                )
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _semester.subjects.length,
              itemBuilder: (context, index) {
                final subject = _semester.subjects[index];
                return SubjectCard(
                  subject: subject,
                  gradeScale: widget.gradeScale,
                  onSubjectChanged: (updatedSubject) {
                    _updateSubject(index, updatedSubject);
                  },
                  onDelete: () => _deleteSubject(index),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _addSubject,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add),
                        SizedBox(width: 8),
                        Text('Add Subject'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Delete Semester'),
                          content: const Text('Are you sure you want to delete this semester?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(dialogContext),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext); // أغلق الـ dialog
                                Navigator.pop(context); // ارجع للشاشة الرئيسية
                                widget.onDelete(); // احذف الـ semester
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      foregroundColor: Colors.red,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delete_outline),
                        SizedBox(width: 8),
                        Text('Delete Semester'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubjectCard extends StatelessWidget {
  final Subject subject;
  final GradeScale gradeScale;
  final Function(Subject) onSubjectChanged;
  final VoidCallback onDelete;

  const SubjectCard({
    super.key,
    required this.subject,
    required this.gradeScale,
    required this.onSubjectChanged,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
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
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: subject.name),
                  decoration: const InputDecoration(
                    hintText: 'Subject Name',
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                  onChanged: (value) {
                    onSubjectChanged(subject.copyWith(name: value));
                  },
                ),
              ),
              IconButton(
                onPressed: onDelete,
                icon: const Icon(Icons.delete_outline, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // عدد الساعات - اختيار من 1 إلى 5
          Row(
            children: [
              const Icon(Icons.schedule, size: 20, color: Colors.grey),
              const SizedBox(width: 8),
              const Text(
                'Credits:',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF1E293B)
                      : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: DropdownButton<int>(
                  value: subject.credits,
                  underline: Container(),
                  items: [1, 2, 3, 4, 5].map((credits) {
                    return DropdownMenuItem(
                      value: credits,
                      child: Text(
                        '$credits',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      onSubjectChanged(subject.copyWith(credits: value));
                    }
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // الدرجة
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? const Color(0xFF0F172A)
                  : Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButton<String>(
              value: gradeScale.grades.any((g) => g.letter == subject.grade)
                  ? subject.grade
                  : gradeScale.grades.first.letter,
              isExpanded: true,
              underline: Container(),
              items: gradeScale.grades.map((grade) {
                return DropdownMenuItem(
                  value: grade.letter,
                  child: Text(
                    '${grade.letter} (${grade.value})',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  onSubjectChanged(subject.copyWith(grade: value));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

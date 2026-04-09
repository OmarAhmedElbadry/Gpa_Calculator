import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/dashboard_screen.dart';
import 'screens/planner_screen.dart';
import 'screens/semesters_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart';
import 'models/semester.dart';
import 'models/grade_scale.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GPACalculatorApp());
}

class GPACalculatorApp extends StatefulWidget {
  const GPACalculatorApp({super.key});

  @override
  State<GPACalculatorApp> createState() => _GPACalculatorAppState();
}

class _GPACalculatorAppState extends State<GPACalculatorApp> {
  bool _isDarkMode = false;
  bool _hasSeenOnboarding = false;
  bool _isLoading = true;
  bool _showSplash = true;

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isDarkMode = prefs.getBool('isDarkMode') ?? false;
      _hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
      _isLoading = false;
    });
  }

  Future<void> _toggleTheme(bool isDark) async {
    setState(() {
      _isDarkMode = isDark;
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', isDark);
  }

  void _completeOnboarding() {
    setState(() {
      _hasSeenOnboarding = true;
    });
  }

  void _completeSplash() {
    setState(() {
      _showSplash = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return MaterialApp(
        title: 'GPA Calculator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (_showSplash) {
      return MaterialApp(
        title: 'GPA Calculator',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        home: SplashScreen(onComplete: _completeSplash),
      );
    }

    return MaterialApp(
      title: 'GPA Calculator',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: _hasSeenOnboarding
          ? MainScreen(onThemeChanged: _toggleTheme, isDarkMode: _isDarkMode)
          : OnboardingScreen(onComplete: _completeOnboarding),
    );
  }
}

class MainScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;
  final bool isDarkMode;

  const MainScreen({
    super.key,
    required this.onThemeChanged,
    required this.isDarkMode,
  });

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Semester> semesters = [];
  GradeScale gradeScale = GradeScale.standard();
  double targetGPA = 3.70;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Load semesters
    final semestersJson = prefs.getStringList('semesters');
    if (semestersJson != null) {
      setState(() {
        semesters = semestersJson
            .map((json) => Semester.fromJson(json))
            .toList();
      });
    }

    // Load grade scale
    final gradeScaleJson = prefs.getString('gradeScale');
    if (gradeScaleJson != null) {
      setState(() {
        gradeScale = GradeScale.fromJson(gradeScaleJson);
      });
    }

    // Load target GPA
    setState(() {
      targetGPA = prefs.getDouble('targetGPA') ?? 3.70;
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'semesters',
      semesters.map((s) => s.toJson()).toList(),
    );
    await prefs.setString('gradeScale', gradeScale.toJson());
    await prefs.setDouble('targetGPA', targetGPA);
  }

  void _updateSemesters(List<Semester> newSemesters) {
    setState(() {
      semesters = newSemesters;
    });
    _saveData();
  }

  void _updateGradeScale(GradeScale newScale) {
    setState(() {
      gradeScale = newScale;
    });
    _saveData();
  }

  void _updateTargetGPA(double newTarget) {
    setState(() {
      targetGPA = newTarget;
    });
    _saveData();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      DashboardScreen(
        semesters: semesters,
        targetGPA: targetGPA,
        gradeScale: gradeScale,
        onThemeToggle: () => widget.onThemeChanged(!widget.isDarkMode),
        isDarkMode: widget.isDarkMode,
      ),
      PlannerScreen(
        semesters: semesters,
        targetGPA: targetGPA,
        gradeScale: gradeScale,
        onTargetGPAChanged: _updateTargetGPA,
        onThemeToggle: () => widget.onThemeChanged(!widget.isDarkMode),
        isDarkMode: widget.isDarkMode,
      ),
      SemestersScreen(
        semesters: semesters,
        gradeScale: gradeScale,
        onSemestersChanged: _updateSemesters,
        onThemeToggle: () => widget.onThemeChanged(!widget.isDarkMode),
        isDarkMode: widget.isDarkMode,
      ),
      SettingsScreen(
        gradeScale: gradeScale,
        isDarkMode: widget.isDarkMode,
        onGradeScaleChanged: _updateGradeScale,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.dashboard_outlined, Icons.dashboard, 'Dashboard'),
                _buildNavItem(1, Icons.track_changes_outlined, Icons.track_changes, 'Planner'),
                _buildNavItem(2, Icons.menu_book_outlined, Icons.menu_book, 'Semesters'),
                _buildNavItem(3, Icons.settings_outlined, Icons.settings, 'Settings'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlinedIcon, IconData filledIcon, String label) {
    final isSelected = _selectedIndex == index;
    final theme = Theme.of(context);
    
    return InkWell(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlinedIcon,
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withOpacity(0.6),
              size: 28,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

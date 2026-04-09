# GPA Calculator - Complete Setup & Usage Guide

## 🚀 Quick Start

### Step 1: Prerequisites Check
Before starting, ensure you have:
- ✅ Flutter SDK 3.0+ installed
- ✅ Dart SDK 3.0+ installed
- ✅ Android Studio OR VS Code with Flutter extension
- ✅ For iOS: Xcode and CocoaPods (Mac only)

**Verify Installation:**
```bash
flutter doctor
```

### Step 2: Project Setup
```bash
# Navigate to project directory
cd gpa_calculator

# Get all dependencies
flutter pub get

# Verify everything is working
flutter analyze
```

### Step 3: Run the App
```bash
# Run in debug mode
flutter run

# Or select specific device
flutter devices          # List available devices
flutter run -d <device-id>
```

## 📱 Platform-Specific Instructions

### Android
1. Connect Android device via USB (with USB debugging enabled)
   OR
2. Start Android emulator from Android Studio

```bash
flutter run
```

**Build APK:**
```bash
flutter build apk --release
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

### iOS (Mac only)
1. Open iOS Simulator or connect iPhone
2. Install CocoaPods dependencies:
```bash
cd ios
pod install
cd ..
```

3. Run the app:
```bash
flutter run
```

**Build IPA:**
```bash
flutter build ios --release
```

### Web
```bash
flutter run -d chrome
```

## 🎯 Feature Walkthrough

### 1. Dashboard Screen
**What you'll see:**
- Large circular GPA indicator (0.00 - 4.00)
- Three stat cards: Credits, Semesters, Best GPA
- Target Progress card showing current vs target
- What-If Simulator (when you have in-progress semesters)

**Actions:**
- Tap moon/sun icon to toggle dark mode
- View all your academic progress at a glance

### 2. Creating Your First Semester

**Step-by-step:**
1. Tap **"Semesters"** in bottom navigation
2. Tap **"Add Semester"** button
3. You'll be taken to semester detail screen
4. Change "New Semester" to your semester name (e.g., "Fall 2024")
5. Tap **"Add Subject"** to add courses

**Adding Subjects:**
1. Tap on "New Subject" to rename it
2. Credits are set to 3 by default (tap to change)
3. Tap the grade dropdown to select grade (A, B, C, etc.)
4. Repeat for all your courses

**Example:**
```
Semester: Fall 2024
- Calculus I: 4 credits, Grade: A (4.0)
- Physics I: 4 credits, Grade: A- (3.7)
- English Comp: 3 credits, Grade: B+ (3.3)
- Chemistry: 4 credits, Grade: A (4.0)
```

### 3. Setting Up Target Planning

1. Go to **"Planner"** tab
2. **Set Target GPA:**
   - Drag the slider to set your goal (e.g., 3.70)
   - Current and target GPAs are displayed

3. **Choose Next Semester Credits:**
   - Select from dropdown: 9, 12, 15, 18, or 21 credits
   - Most common: 15 credits

4. **View Results:**
   - Required GPA shows what you need to achieve
   - Color coding: Green (achievable) or Orange (challenging)
   - Suggested grade distribution shows recommended grades

**Interpretation:**
- Required GPA ≤ 4.0: Achievable with good effort
- Required GPA > 4.0: You may need to take more credits or adjust target

### 4. Using What-If Simulator

**Setup:**
1. Go to **Semesters** tab
2. Open an existing semester
3. *Keep grades as they are* OR *create a new semester with tentative grades*
4. System automatically shows simulator on Dashboard

**Using the Simulator:**
1. Go to **Dashboard**
2. Find **"What-If Simulator"** card at bottom
3. Tap to expand it
4. Adjust grade sliders for each course
5. Watch simulated GPA update in real-time
6. See difference from current GPA (+/- shown in small text)

**Use Cases:**
- "What if I get all A's this semester?"
- "How much will a B in this course affect my GPA?"
- "Can I still reach my target if I get a C in one course?"

### 5. Customizing Grade Scale

**Default Scale (4.0):**
- A+/A = 4.0
- A- = 3.7
- B+ = 3.3
- B = 3.0
- B- = 2.7
- C+ = 2.3
- C = 2.0
- C- = 1.7
- D+ = 1.3
- D = 1.0
- F = 0.0

**To Customize:**
1. Go to **Settings** tab
2. Tap on **"Grading System"** card
3. Tap edit icon (pencil)
4. Modify existing grades:
   - Change letter (e.g., "A+" to "A1")
   - Change value (e.g., 4.0 to 4.3)
5. Add new grades with **"Add Grade"** button
6. Delete grades with trash icon
7. Tap **"Save Changes"**

**Example Custom Scale:**
```
A+ = 4.3
A = 4.0
A- = 3.7
...continue as needed
```

### 6. Managing Multiple Semesters

**View All Semesters:**
- Go to **Semesters** tab
- See list of all semesters
- Green badge shows semester GPA
- Blue "In Progress" badge for ongoing semesters

**Edit Semester:**
- Tap on any semester card
- Modify name, subjects, grades
- Changes save automatically

**Delete Semester:**
1. Tap on semester to open
2. Scroll to bottom
3. Tap red **"Delete Semester"** button
4. Confirm deletion

**Best Practices:**
- Create new semester at start of term
- Update grades as you receive them
- Mark semester as "In Progress" for simulations
- Keep completed semesters for history

## ⚙️ Settings & Customization

### Dark Mode
**Toggle Methods:**
1. Tap moon/sun icon in top-right of any screen
2. OR go to Settings → Toggle "Dark Mode" switch

**Features:**
- Smooth transition animation
- Preference saved automatically
- Consistent across all screens
- Reduces eye strain in low light

### App Information
- View app version
- See app description
- Located at bottom of Settings screen

## 📊 Understanding GPA Calculations

### How GPA is Calculated
```
GPA = (Sum of all grade points) / (Total credits)

Where:
Grade Points = Grade Value × Credits

Example:
Subject 1: A (4.0) × 3 credits = 12 points
Subject 2: B+ (3.3) × 4 credits = 13.2 points
Subject 3: A- (3.7) × 3 credits = 11.1 points
Total: 36.3 points / 10 credits = 3.63 GPA
```

### Cumulative GPA
Calculated across all completed semesters:
```
Cumulative GPA = (All semester points) / (All credits)
```

### Target GPA Planning
```
Required GPA = (Target × Total Future Credits - Current Points) / Next Semester Credits

Example:
Current GPA: 3.50 with 30 credits
Target GPA: 3.70
Next Semester: 15 credits

Required = (3.70 × 45 - 3.50 × 30) / 15
         = (166.5 - 105) / 15
         = 61.5 / 15
         = 4.10 (Challenging but possible!)
```

## 🎨 Customization Tips

### Changing App Colors
Edit `lib/utils/theme.dart`:

```dart
// Change primary green
static const Color primaryGreen = Color(0xFF2DD4BF); // Your color

// Change primary blue
static const Color primaryBlue = Color(0xFF6366F1); // Your color
```

### Adding More Credit Options
Edit `lib/screens/planner_screen.dart`:

```dart
items: [9, 12, 15, 18, 21, 24].map((credits) { // Add 24
```

## 🔧 Troubleshooting

### Issue: App won't start
**Solution:**
```bash
flutter clean
rm -rf build/
flutter pub get
flutter run
```

### Issue: "Packages not found"
**Solution:**
```bash
flutter pub get
flutter pub upgrade
```

### Issue: Dark mode not persisting
**Solution:**
- Check device storage permissions
- Clear app data and restart
- Reinstall app

### Issue: GPA calculation seems wrong
**Solution:**
1. Verify grade scale values in Settings
2. Check that all subjects have correct credits
3. Ensure no duplicate subjects
4. Verify grade letters match grade scale exactly

### Issue: iOS build fails
**Solution:**
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter run
```

### Issue: Data lost after update
**Solution:**
- Data is stored locally per app installation
- Uninstalling app clears all data
- Consider adding export/import feature

## 📈 Pro Tips

### Academic Success
1. **Set Realistic Targets:** Aim for 0.1-0.2 GPA increase per semester
2. **Plan Ahead:** Use target planner before semester starts
3. **Regular Updates:** Update grades after each exam
4. **Use What-If:** Experiment with different scenarios
5. **Track Trends:** Monitor your best semester GPA

### App Usage
1. **Weekly Check-ins:** Update app weekly with latest grades
2. **Semester Planning:** Use planner before registration
3. **Grade Verification:** Double-check all entered grades
4. **Backup Strategy:** Take screenshots of important data
5. **Dark Mode:** Use at night to reduce eye strain

### Performance Optimization
1. **Limit Semesters:** Archive old semesters if app slows
2. **Regular Updates:** Keep Flutter and dependencies updated
3. **Clean Builds:** Run `flutter clean` monthly

## 🚀 Advanced Usage

### Creating Multiple Profiles
Currently single profile - but you can:
1. Use different grade scales for different institutions
2. Create separate "profiles" as different semesters
3. Name semesters descriptively (e.g., "Freshman Year")

### Exporting Data
Manual export (future feature):
1. Copy values from each screen
2. Save in spreadsheet
3. Import by manually re-entering

### Grade Prediction
Use What-If Simulator:
1. Create next semester with estimated grades
2. Mark as "In Progress"
3. Adjust grades to see impact
4. Plan which courses to focus on

## 🎓 Use Case Examples

### Scenario 1: Freshman Planning
```
Goal: Maintain 3.5+ GPA
Credits per semester: 15
Strategy:
- Set target GPA: 3.50
- Use planner to see required GPA
- Aim for mostly A's and B+'s
- Use simulator to test grade combinations
```

### Scenario 2: GPA Recovery
```
Current: 2.8 GPA after 60 credits
Goal: 3.0 GPA by graduation (120 credits)
Strategy:
- Set target: 3.00
- Plan next 60 credits
- Calculate required GPA (3.20)
- Focus on achievable high grades
```

### Scenario 3: Pre-med/Law School
```
Goal: 3.8+ GPA
Strategy:
- Set aggressive target: 3.80
- Take manageable credit loads (12-15)
- Use simulator before each semester
- Monitor best semester GPA metric
```

## 📞 Support & Resources

### Flutter Resources
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Flutter Codelabs](https://flutter.dev/docs/codelabs)

### Development Tools
- VS Code Flutter Extension
- Android Studio Flutter Plugin
- Flutter DevTools

### Community
- Stack Overflow (flutter tag)
- Flutter Discord
- GitHub Issues

## 🔄 Future Feature Ideas

Potential additions:
- [ ] Cloud sync across devices
- [ ] Export to PDF/CSV
- [ ] Grade notifications/reminders
- [ ] Analytics and trends
- [ ] Course recommendations
- [ ] Study time tracking
- [ ] GPA comparison with peers
- [ ] Scholarship GPA tracking
- [ ] Multiple student profiles
- [ ] Widget support

## ✅ Checklist for First-Time Setup

- [ ] Install Flutter SDK
- [ ] Run `flutter doctor` successfully
- [ ] Navigate to project folder
- [ ] Run `flutter pub get`
- [ ] Connect device or start emulator
- [ ] Run `flutter run`
- [ ] Add first semester
- [ ] Add at least 3 subjects with grades
- [ ] Set target GPA
- [ ] Toggle dark mode
- [ ] Explore all 4 tabs
- [ ] Try what-if simulator
- [ ] Customize grade scale
- [ ] Take screenshots of progress!

## 🎉 Congratulations!

You're now ready to use the GPA Calculator app to track and improve your academic performance!

Remember:
- Update regularly
- Set realistic goals
- Use all features
- Monitor progress
- Stay motivated!

Good luck with your studies! 📚🎓

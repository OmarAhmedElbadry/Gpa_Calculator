# GPA Calculator - Quick Reference Card

## 🚀 Quick Start (5 Minutes)

### Setup
```bash
cd gpa_calculator
flutter pub get
flutter run
```

### First Time Use
1. Open app → Go to "Semesters" tab
2. Tap "Add Semester" → Name it (e.g., "Fall 2024")
3. Tap "Add Subject" → Enter name, credits, grade
4. Repeat for all courses → Auto-saved!
5. View your GPA on Dashboard

---

## 📱 Screen Navigation

| Tab | Icon | Purpose |
|-----|------|---------|
| Dashboard | 📊 | View GPA, stats, progress |
| Planner | 🎯 | Set targets, plan ahead |
| Semesters | 📚 | Manage courses & grades |
| Settings | ⚙️ | Theme, grade scale, info |

---

## 🎯 Common Tasks

### Add New Semester
```
Semesters → Add Semester → Enter details → Add subjects
```

### Change Grade
```
Semesters → Select semester → Tap subject → Choose grade
```

### Set Target GPA
```
Planner → Drag slider → Select credits → View required GPA
```

### What-If Simulation
```
Create semester → Mark in-progress → Dashboard → Adjust sliders
```

### Toggle Dark Mode
```
Tap moon/sun icon (top-right) OR Settings → Dark Mode toggle
```

### Edit Grade Scale
```
Settings → Grading System → Edit icon → Modify → Save
```

---

## 💡 Pro Tips

| Tip | Description |
|-----|-------------|
| **Weekly Updates** | Update grades after each exam/assignment |
| **Realistic Targets** | Aim for 0.1-0.2 GPA increase per semester |
| **Use Simulator** | Test scenarios before semester starts |
| **Dark Mode** | Better for night studying |
| **Check Required GPA** | Plan course difficulty based on requirements |

---

## 🔢 Understanding Numbers

### Your GPA Display
```
3.75  → Excellent (Dean's List territory)
3.50  → Very Good (Most scholarships)
3.00  → Good (Graduate school minimum)
2.50  → Fair (Some programs minimum)
2.00  → Pass (Academic warning zone)
```

### Target Progress
- **Green "On Track"**: Current ≥ Target
- **Orange "Behind"**: Current < Target
- **Number**: Difference from target

### Required Next Semester
- **≤ 3.5**: Very achievable
- **3.5-4.0**: Achievable with effort
- **> 4.0**: Consider more credits or adjust target

---

## ⚡ Keyboard Shortcuts & Gestures

| Action | Method |
|--------|--------|
| **Switch tabs** | Tap bottom icons |
| **Edit field** | Tap text to edit |
| **Delete item** | Tap trash icon |
| **Save changes** | Automatic on edit |
| **Go back** | Back button or swipe |
| **Expand card** | Tap card header |

---

## 🎨 Theme Colors

### Light Mode
- Background: Light gray (#F5F5F5)
- Cards: White
- Primary: Teal (#2DD4BF)
- Buttons: Indigo (#6366F1)

### Dark Mode
- Background: Dark blue (#0F172A)
- Cards: Slate (#1E293B)
- Primary: Teal (#2DD4BF)
- Buttons: Indigo (#6366F1)

---

## 📊 Default Grade Scale

| Grade | Value | Grade | Value |
|-------|-------|-------|-------|
| A+/A  | 4.0   | C+    | 2.3   |
| A-    | 3.7   | C     | 2.0   |
| B+    | 3.3   | C-    | 1.7   |
| B     | 3.0   | D+    | 1.3   |
| B-    | 2.7   | D/F   | 1.0/0 |

---

## 🔧 Troubleshooting

### App won't start
```bash
flutter clean
flutter pub get
flutter run
```

### Grades not calculating
- Check all subjects have valid grades
- Verify grade scale matches entered grades
- Ensure credits are correct numbers

### Dark mode not working
- Toggle switch in Settings
- Check system theme settings
- Restart app

### Data disappeared
- Check correct semester selected
- Data only persists on same device
- Reinstalling app clears data

---

## 📞 Quick Help

| Issue | Solution |
|-------|----------|
| Can't add semester | Check if app has storage permission |
| GPA shows 0.00 | Add subjects with grades first |
| Target unrealistic | Adjust target or increase credits |
| What-if not showing | Mark semester as "In Progress" |
| Theme stuck | Force stop and restart app |

---

## 🎓 Academic Planning Tips

### Semester Planning
1. Set target before registration
2. Use planner to see required GPA
3. Balance hard/easy courses
4. Consider workload (jobs, activities)
5. Plan for worst-case scenarios

### Grade Management
- **A Strategy**: Focus on achievable A's
- **B+ Insurance**: Maintain high B's as backup
- **C Avoidance**: Drop if falling below B-
- **GPA Boost**: Retake failed courses
- **Extra Credits**: Take summer courses

### Long-term Goals
- **Graduation**: Minimum GPA (usually 2.0)
- **Honors**: 3.5+ (cum laude)
- **Dean's List**: 3.5-3.75+ per semester
- **Grad School**: 3.0-3.5+ depending on program
- **Competitive Programs**: 3.7+ (med, law, PhD)

---

## 🔐 Data & Privacy

- ✅ All data stored locally on device
- ✅ No internet connection needed
- ✅ No account required
- ✅ No personal info collected
- ✅ No ads or tracking
- ❌ No cloud backup (manual only)
- ❌ No data sharing
- ❌ Not recoverable after uninstall

---

## 📝 Use Case Examples

### Example 1: Freshman Planning
```
Current: 0 credits, 0 GPA
Target: 3.5
Strategy:
  - Take 15 credits
  - Need 3.5 GPA (all A's and B+'s)
  - Use simulator to test combinations
```

### Example 2: Junior Recovery
```
Current: 60 credits, 2.8 GPA
Target: 3.0 (graduate)
Next: 15 credits
Required: 3.4 GPA (achievable!)
Strategy:
  - 3-4 A's needed
  - Focus on subjects you excel at
```

### Example 3: Senior Sprint
```
Current: 90 credits, 3.6 GPA
Target: 3.7 (cum laude)
Next: 15 credits
Required: 3.9 GPA (challenging!)
Strategy:
  - Take easier electives
  - Maximum effort on all courses
  - Consider 12 credits instead
```

---

## 🎯 Feature Checklist

Core Features:
- [x] Add/edit/delete semesters
- [x] Add/edit/delete subjects
- [x] Automatic GPA calculation
- [x] Cumulative GPA tracking
- [x] Target GPA planning
- [x] Required GPA calculator
- [x] Grade distribution suggestions
- [x] What-if grade simulator
- [x] Dark/light themes
- [x] Custom grade scales
- [x] Local data persistence
- [x] Beautiful UI/UX

---

## 📚 Additional Resources

### In Project
- `README.md`: Overview and features
- `SETUP_GUIDE.md`: Detailed setup instructions
- `PROJECT_STRUCTURE.md`: Technical architecture
- This file: Quick reference

### Online
- Flutter Docs: https://flutter.dev/docs
- Material Design: https://m3.material.io
- Dart Language: https://dart.dev

---

## 🎉 Quick Win Checklist

**First Day:**
- [ ] Install and run app
- [ ] Add current semester
- [ ] Enter all courses and grades
- [ ] View calculated GPA
- [ ] Toggle dark mode

**First Week:**
- [ ] Add all past semesters
- [ ] Set target GPA for graduation
- [ ] Use planner for next semester
- [ ] Experiment with what-if simulator
- [ ] Customize grade scale (if needed)

**Ongoing:**
- [ ] Update grades weekly
- [ ] Use planner before registration
- [ ] Check target progress monthly
- [ ] Adjust targets as needed
- [ ] Keep all data current

---

## 💯 Success Metrics

Track your progress:
- **Current GPA**: ___.___ / 4.00
- **Target GPA**: ___.___ / 4.00
- **Credits Completed**: _____ / _____
- **Semesters Completed**: ___ / ___
- **Best Semester GPA**: ___.___ 
- **Days to Graduation**: _______

---

**Print this card and keep it handy!** 📄

*Last Updated: v1.0.0*

# Testing Guide for Reusable Widgets

This guide will help you test all features of the reusable widgets package using the example app.

## Quick Start

1. **Navigate to example app:**
   ```bash
   cd example/exampletestapp
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the app:**
   ```bash
   flutter run
   ```

## Testing Features Step by Step

### 1. Widget Gallery Testing

**Location:** Home → Widget Gallery

**What to Test:**

- [ ] **Reusable Container**
  - Verify custom border radius
  - Check border color and width
  - Confirm background color

- [ ] **Reusable Badge**
  - Test different colors (red, orange, green)
  - Verify label text displays correctly
  - Check badge sizing

- [ ] **Reusable Circle Avatar**
  - Test with icon
  - Test with image URL
  - Test with text initials
  - Verify radius customization

- [ ] **Reusable Icon Buttons**
  - Click each button (favorite, share, bookmark)
  - Verify toast messages appear
  - Check icon colors

- [ ] **Reusable Dividers**
  - Test horizontal divider
  - Test vertical divider
  - Verify thickness and color

- [ ] **Reusable Shimmer**
  - Click "Start Loading" button
  - Verify shimmer effect appears
  - Click "Stop Loading" to show content
  - Confirm smooth transition

- [ ] **Reusable Error View**
  - Check error message displays
  - Click "Retry" button
  - Verify toast message appears

- [ ] **Reusable Animated Switcher**
  - Click "Toggle Content"
  - Verify smooth fade transition
  - Check content changes between states

- [ ] **Toast & Snackbar**
  - Click "Show Toast"
  - Verify toast appears at bottom
  - Click "Show Snackbar"
  - Verify snackbar appears with action

**Expected Results:**
- All widgets render correctly
- Interactions work smoothly
- No visual glitches
- Proper spacing and alignment

---

### 2. Form Widgets Testing

**Location:** Home → Form Widgets

**What to Test:**

- [ ] **Text Form Fields**
  - Enter name → verify input works
  - Enter invalid email → verify validation error
  - Enter valid email → error should clear
  - Enter password → verify obscure text
  - Click eye icon → verify password visibility toggle
  - Enter phone number → verify keyboard type

- [ ] **Dropdown**
  - Click dropdown → verify menu opens
  - Select a country → verify selection works
  - Verify hint text before selection
  - Check validation on submit

- [ ] **Date Picker**
  - Click date picker field
  - Select a date
  - Verify toast shows selected date
  - Check date format

- [ ] **Radio Group**
  - Select each gender option
  - Verify only one can be selected
  - Check visual feedback

- [ ] **Form Validation**
  - Click "Submit Form" with empty fields
  - Verify all validation errors appear
  - Fill all fields correctly
  - Submit → verify success dialog shows all data

- [ ] **Form Reset**
  - Fill some fields
  - Click "Reset Form"
  - Verify all fields cleared
  - Check toast message appears

**Expected Results:**
- Validation works correctly
- Error messages are clear
- Form submission shows correct data
- Reset clears all fields

---

### 3. Theme System Testing

**Location:** Home → Theme System

**What to Test:**

- [ ] **Theme Mode Toggle**
  - Click "Light" → note the UI (won't change in demo)
  - Click "Dark" → check snackbar message
  - Click "System" → verify selection

- [ ] **Color Palette**
  - Verify all color cards display
  - Check hex codes are visible
  - Confirm colors match their labels

- [ ] **Typography**
  - Verify all text styles render correctly
  - Check font sizes are different
  - Confirm hierarchy is clear

- [ ] **Component Theming**
  - Check all buttons render with theme colors
  - Verify chip component
  - Test button interactions

- [ ] **Custom Widgets**
  - Verify containers use theme colors
  - Check contrast (text should be readable)

**Expected Results:**
- Theme colors display correctly
- Typography hierarchy is clear
- Components use theme consistently
- Good color contrast

---

### 4. Navigation Testing

**Location:** Home → Navigation

**What to Test:**

- [ ] **App Bar**
  - Verify title displays
  - Check back button works
  - Click notification icon → verify snackbar

- [ ] **Drawer Navigation**
  - Open drawer (swipe right or tap menu)
  - Verify user header displays
  - Click each menu item:
    - Home → check snackbar
    - Profile → check snackbar
    - Settings → check snackbar
    - About → check snackbar
  - Verify drawer closes after selection

- [ ] **Tab Bar**
  - Switch between tabs (Tab 1, 2, 3)
  - Verify content changes
  - Check icons and labels
  - Verify smooth transitions

- [ ] **Bottom Navigation**
  - Click each nav item (Home, Search, Profile, Settings)
  - Verify selected state changes
  - Check snackbar shows navigation
  - Verify current selection shows in tab content

- [ ] **Stack Navigation**
  - Click "Navigate to Detail" in any tab
  - Verify detail screen opens
  - Check back button works
  - Verify returns to previous screen

**Expected Results:**
- All navigation patterns work
- No navigation stack issues
- Smooth transitions
- Proper state management

---

### 5. API Client Testing

**Location:** Home → API Client

**What to Test:**

- [ ] **GET Request (List)**
  - Click "GET Request"
  - Verify shimmer appears
  - Wait for response
  - Check users list displays (5 items)
  - Verify user cards show ID, name, email

- [ ] **GET Single Item**
  - Click "GET Single Item"
  - Verify shimmer appears
  - Wait for response
  - Check user details card displays
  - Verify all fields (ID, name, email, phone, website)

- [ ] **POST Request**
  - Click "POST Request"
  - Verify shimmer appears
  - Wait for response
  - Check success dialog appears
  - Verify post ID and title shown

- [ ] **Error Handling**
  - Click "Simulate Error"
  - Verify shimmer appears
  - Wait for error
  - Check error view displays
  - Click "Retry" on error view
  - Verify error clears

**Expected Results:**
- All requests succeed (internet required)
- Loading states show correctly
- Error handling works
- Data displays properly

**Note:** This requires internet connection. If offline, all requests will show errors.

---

### 6. Offline & Connectivity Testing

**Location:** Home → Offline & Connectivity

**What to Test:**

- [ ] **Hive Initialization**
  - Check "Status" shows "Initialized"
  - Verify "Items Count" displays

- [ ] **Add Data**
  - Enter key: "test_key"
  - Enter value: "test_value"
  - Click "Save to Cache"
  - Verify success toast appears
  - Check data appears in list below

- [ ] **Add Sample Data**
  - Click "Add Sample Data"
  - Verify toast confirms addition
  - Check 4 items appear in list
  - Verify data: user_name, user_email, timestamp, app_version

- [ ] **Delete Data**
  - Click delete icon on any item
  - Verify item removed from list
  - Check toast shows deletion

- [ ] **Clear All**
  - Click "Clear All"
  - Verify all items removed
  - Check empty state displays
  - Verify toast confirms clearing

- [ ] **Reload Data**
  - Add some data
  - Click "Reload Data"
  - Verify data still displays (confirms persistence)

- [ ] **Show Box Info**
  - Click "Show Box Info"
  - Verify dialog shows:
    - Box name
    - Path
    - Item count
    - Open status
    - Keys list

- [ ] **Persistence Test** (Important!)
  - Add some data
  - Close the app completely
  - Reopen the app
  - Navigate to Offline & Connectivity
  - Verify data is still there
  - ✅ This confirms data persists across app restarts

**Expected Results:**
- Data saves successfully
- Data persists after app restart
- CRUD operations work correctly
- UI updates immediately

---

## Integration Testing

Test multiple features together:

### Scenario 1: Form → API → Offline
1. Fill form with user data
2. Submit form
3. Navigate to API Client
4. Fetch users from API
5. Navigate to Offline
6. Save user data to cache
7. Close app, reopen
8. Verify data persists

### Scenario 2: Theme → Navigation → Widgets
1. View theme colors
2. Use navigation to switch views
3. Test widgets in different theme modes
4. Verify consistent styling

### Scenario 3: End-to-End Flow
1. Start from home
2. Visit each screen
3. Interact with each feature
4. Navigate back to home
5. Verify no crashes or errors

---

## Performance Testing

### 1. Memory Usage
- Navigate through all screens
- Monitor for memory leaks
- Check app remains responsive

### 2. Smooth Animations
- Test all transitions
- Verify 60fps on interactions
- Check no jank during navigation

### 3. Loading States
- Verify shimmer performs well
- Check API calls don't block UI
- Test rapid navigation

---

## Platform-Specific Testing

### Android
- Test on different screen sizes
- Verify Material design compliance
- Check back button behavior
- Test keyboard interactions

### iOS
- Verify Cupertino widgets where appropriate
- Check swipe gestures
- Test safe area handling
- Verify keyboard dismissal

### Web
- Test responsive layout
- Check mouse interactions
- Verify keyboard shortcuts
- Note: Hive may have limitations

### Desktop (Windows/macOS/Linux)
- Test window resizing
- Verify keyboard navigation
- Check mouse hover states
- Test desktop-specific interactions

---

## Common Issues & Solutions

### Issue: Package not found
**Solution:**
```bash
cd example/exampletestapp
flutter clean
flutter pub get
```

### Issue: Build fails
**Solution:**
- Check Flutter version (3.4.1+)
- Verify path dependency in pubspec.yaml
- Run `flutter doctor`

### Issue: Widgets don't display
**Solution:**
- Check imports are correct
- Verify widget exports in main package
- Check for null safety issues

### Issue: Hive errors
**Solution:**
- Check Hive.initFlutter() called in main
- Verify box name is correct
- Clear app data and restart

### Issue: API calls fail
**Solution:**
- Check internet connection
- Verify URL is correct
- Check CORS for web platform

---

## Reporting Issues

When reporting issues, include:

1. **Platform:** Android/iOS/Web/Desktop
2. **Flutter version:** Run `flutter --version`
3. **Steps to reproduce**
4. **Expected behavior**
5. **Actual behavior**
6. **Screenshots/video** if applicable
7. **Error logs** from console

---

## Next Steps

After testing the example app:

1. **Understand the code:** Review each demo screen
2. **Modify widgets:** Edit main package widgets and see changes
3. **Add features:** Create new demo screens
4. **Use in your app:** Copy patterns to your project
5. **Customize:** Adapt widgets to your needs

---

## Testing Checklist Summary

- [ ] All widgets render correctly
- [ ] All forms validate properly
- [ ] Theme system works
- [ ] Navigation is smooth
- [ ] API calls succeed
- [ ] Offline storage persists
- [ ] No crashes or errors
- [ ] Performance is good
- [ ] Works on target platform
- [ ] Ready to use in production

---

## Support

If you need help:
- Read the README.md
- Review the code examples
- Check main package documentation
- Open an issue on GitHub

Happy Testing! 🎉

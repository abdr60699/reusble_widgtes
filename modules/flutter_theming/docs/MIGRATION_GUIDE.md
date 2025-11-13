# Migration Guide

Version management, schema evolution, and upgrade paths for the theming system.

## Table of Contents

1. [Schema Versioning](#schema-versioning)
2. [Token Evolution](#token-evolution)
3. [Migration Strategies](#migration-strategies)
4. [Backward Compatibility](#backward-compatibility)
5. [Breaking Changes](#breaking-changes)
6. [Upgrade Procedures](#upgrade-procedures)

---

## Schema Versioning

### Theme Config Schema

**Current Version**: 1

**Schema Structure**:
```
AppTheme {
  id: String
  name: String
  description: String?
  mode: AppThemeMode (light/dark/custom)
  tokens: DesignTokens {...}
  version: int  ← Schema version
  createdAt: DateTime
  modifiedAt: DateTime
  isBuiltIn: bool
}
```

### Version Numbering

**Semantic Versioning for Schemas**:
```
Version format: MAJOR

Version 1:
  - Initial schema
  - Core tokens: colors, typography, spacing, radii, elevations

Version 2 (hypothetical future):
  - Add new token categories: animations, gradients
  - Add new color tokens: tertiary, tertiaryContainer
  - Maintain all v1 tokens (backward compatible)

Version 3 (hypothetical future):
  - Major restructure
  - May remove deprecated tokens
  - Migration required
```

### Detecting Schema Version

**On Theme Load**:
```
1. Deserialize theme JSON
2. Check 'version' field
3. Compare to current version:
   - If version == current: Use directly
   - If version < current: Migrate forward
   - If version > current: Incompatible (reject or downgrade)
4. Apply migrated theme
```

---

## Token Evolution

### Adding New Tokens

**Scenario**: Version 2 adds new color token `tertiary`

**Strategy**: Provide default value for missing token

**Implementation**:
```
Migration v1 → v2:
  if (theme.version == 1) {
    // Add new tokens with sensible defaults
    theme.tokens.colors.tertiary = theme.tokens.colors.secondary
    theme.tokens.colors.onTertiary = theme.tokens.colors.onSecondary
    theme.tokens.colors.tertiaryContainer = lighten(theme.tokens.colors.secondary, 20%)
    theme.tokens.colors.onTertiaryContainer = darken(theme.tokens.colors.secondary, 40%)

    // Update version
    theme.version = 2
  }

  return theme
```

**Guideline**: New tokens should have sensible defaults derived from existing tokens.

### Renaming Tokens

**Scenario**: Version 2 renames `primaryVariant` to `primaryContainer` (Material 3 alignment)

**Strategy**: Alias old token to new, deprecate old

**Implementation**:
```
Migration v1 → v2:
  if (theme.version == 1) {
    // Map old token to new name
    theme.tokens.colors.primaryContainer = theme.tokens.colors.primaryVariant

    // Calculate onPrimaryContainer if not present
    if (!theme.tokens.colors.onPrimaryContainer) {
      theme.tokens.colors.onPrimaryContainer = contrasting(
        theme.tokens.colors.primaryContainer
      )
    }

    // Mark primaryVariant as deprecated (keep for backward compat)
    // Remove in version 3

    theme.version = 2
  }
```

**Backward Compatibility**:
- Keep old token name for 1 major version
- Deprecation warning in logs
- Remove in next major version

### Removing Tokens

**Scenario**: Version 3 removes deprecated `primaryVariant`

**Strategy**: Remove after 1 major version deprecation period

**Implementation**:
```
Migration v2 → v3:
  if (theme.version == 2) {
    // Remove deprecated tokens
    delete theme.tokens.colors.primaryVariant

    // Ensure replacement exists
    assert(theme.tokens.colors.primaryContainer != null)

    theme.version = 3
  }
```

**Breaking Change**: Document in CHANGELOG, provide migration guide

### Changing Token Semantics

**Scenario**: Token meaning changes

**Example**: `background` previously meant "canvas background", now means "scaffold background"

**Strategy**: Introduce new token, deprecate old, migrate in next version

**Implementation**:
```
Version 2:
  - Add: scaffoldBackground (new semantic meaning)
  - Keep: background (old meaning, deprecated)
  - Migration: background → scaffoldBackground

Version 3:
  - Remove: background
  - Use: scaffoldBackground exclusively
```

---

## Migration Strategies

### Automatic Migration

**On Theme Load**:
```
ThemeRepository.loadSavedTheme():
  1. Load saved theme JSON
  2. Deserialize to Map
  3. Check version field
  4. If version < current:
     a. Run migration chain:
        migrateV1toV2(theme)
        migrateV2toV3(theme)
        etc.
     b. Validate migrated theme
     c. If valid, save migrated version
  5. Return migrated theme
```

**Migration Chain**:
```
AppTheme migrate(Map json, int fromVersion, int toVersion):
  var theme = AppTheme.fromJson(json)

  // Apply migrations in sequence
  for (int v = fromVersion; v < toVersion; v++) {
    theme = applyMigration(theme, v, v + 1)
  }

  return theme

AppTheme applyMigration(AppTheme theme, int from, int to):
  switch (from, to) {
    case (1, 2):
      return migrateV1toV2(theme)
    case (2, 3):
      return migrateV2toV3(theme)
    default:
      throw UnsupportedMigrationException('$from → $to')
  }
```

### Manual Migration

**User-Initiated Migration**:
```
Scenario: Custom theme from old version

UI Flow:
  1. Detect old custom theme
  2. Show dialog: "Theme needs update for compatibility. Migrate now?"
  3. User confirms
  4. Run migration
  5. Show preview of migrated theme
  6. User approves or reverts
  7. Save migrated theme
```

**Partial Migration**:
```
If migration fails partway:
  1. Log errors
  2. Apply what succeeded
  3. Fill remaining with defaults
  4. Mark theme as "partially migrated"
  5. User can fix manually or reset
```

---

## Backward Compatibility

### Supporting Old Clients

**Strategy**: Support N-1 versions (current + previous major)

**Example**:
```
Current version: 3
Supported versions: 2, 3

Version 1 themes:
  - Auto-migrate to version 3
  - May not be perfect (warn user)
  - Allow manual fixes

Version 2 themes:
  - Auto-migrate to version 3
  - High fidelity migration

Version 3 themes:
  - Use directly

Version 4+ themes:
  - Reject (app too old, needs update)
```

### Fallback Strategies

**If Migration Fails**:
```
1. First Attempt: Auto-migrate
   └─ If fails: Log errors, try partial migration

2. Partial Migration Fails:
   └─ Fall back to closest built-in preset
   └─ Notify user: "Custom theme incompatible, using Light theme"
   └─ Offer manual theme customization

3. All Fails:
   └─ Hard-coded safe default theme
   └─ Always works, minimal styling
```

### Validation After Migration

**Ensure Migrated Theme is Valid**:
```
After migration:
  1. Run ThemeValidator.validateTheme(migratedTheme)
  2. If valid: Use migrated theme
  3. If warnings only: Use but log warnings
  4. If errors:
     a. Try auto-fix (adjust colors for contrast)
     b. If auto-fix succeeds: Use fixed theme
     c. If auto-fix fails: Fall back to preset
```

---

## Breaking Changes

### Identifying Breaking Changes

**Breaking Change Indicators**:
- Removing tokens (without migration path)
- Changing token semantics (without alias)
- Restructuring theme format (incompatible deserialization)
- Changing validation rules (previously valid themes now invalid)

**Non-Breaking Changes**:
- Adding new tokens (with defaults)
- Deprecating tokens (with aliases and warnings)
- Adding validation warnings (not errors)
- Performance improvements

### Documenting Breaking Changes

**CHANGELOG Format**:
```
## [2.0.0] - 2025-12-01

### BREAKING CHANGES

#### Removed `primaryVariant` token
- **Reason**: Aligning with Material 3 design system
- **Replacement**: Use `primaryContainer` instead
- **Migration**: Automatic migration provided
- **Action Required**: Update custom themes to use `primaryContainer`

#### Changed `background` semantic meaning
- **Old**: Canvas background
- **New**: Scaffold background
- **Migration**: Automatic rename to `scaffoldBackground`
- **Action Required**: Review custom themes

### Added

- New color tokens: `tertiary`, `tertiaryContainer`, `onTertiaryContainer`
- Gradient token support
- Animation duration tokens

### Deprecated

- `background` token (use `scaffoldBackground` instead)
- Will be removed in version 3.0.0
```

### Deprecation Policy

**Deprecation Timeline**:
```
Version N: Introduce replacement, deprecate old token
  - Old token still works
  - Deprecation warning logged
  - Documentation updated

Version N+1 (next major): Remove old token
  - Old token removed
  - Migration required
  - Breaking change documented
```

**Example**:
```
Version 1.5: Deprecate `background`, add `scaffoldBackground`
Version 2.0: Remove `background`, use `scaffoldBackground` exclusively
```

---

## Upgrade Procedures

### Upgrading Theming Module

**Step-by-Step Upgrade**:

**1. Review CHANGELOG**
```
Before upgrading, read CHANGELOG for:
  - Breaking changes
  - New features
  - Deprecated tokens
  - Migration guides
```

**2. Update Dependency**
```
pubspec.yaml:
  flutter_theming: ^2.0.0  # Update version

Run:
  flutter pub upgrade flutter_theming
```

**3. Run Automated Migration**
```
On app start after upgrade:
  - ThemeService.initialize() runs
  - Detects old theme version
  - Auto-migrates saved themes
  - Validates migrated themes
  - Logs migration results
```

**4. Review Migration Logs**
```
Check logs for:
  - Successfully migrated themes
  - Warnings (partial migration)
  - Errors (migration failed)
```

**5. Test Themes**
```
Manual testing:
  - Switch to each theme preset
  - Verify custom themes still work
  - Check for visual regressions
  - Test on all platforms
```

**6. Fix Custom Themes**
```
If custom themes have issues:
  - Review migration warnings
  - Manually update theme configs
  - Re-validate with ThemeValidator
  - Test extensively
```

**7. Update App Code (if needed)**
```
If using deprecated tokens in app code:
  - Search for deprecated token names
  - Replace with new equivalents
  - Example: colors.primaryVariant → colors.primaryContainer
```

**8. Deploy**
```
After testing:
  - Deploy updated app
  - Monitor for theme-related issues
  - Provide user support for theme resets if needed
```

### Upgrading Gradually

**Phased Upgrade Strategy**:

**Phase 1: Update Module (Non-Breaking)**
```
- Update to latest minor version (e.g., 1.5.x)
- Gain new features
- No breaking changes
- Deprecation warnings logged
- Low risk
```

**Phase 2: Fix Deprecations**
```
- Address deprecation warnings
- Update custom themes to use new tokens
- Test thoroughly
- Prepare for major version
```

**Phase 3: Major Version Upgrade**
```
- Update to next major version (e.g., 2.0.0)
- Deprecated tokens removed
- Breaking changes applied
- Migration runs automatically
- Higher risk, needs thorough testing
```

### Rollback Plan

**If Upgrade Fails**:

**Option 1: Revert Module Version**
```
1. Revert pubspec.yaml to previous version
2. Run flutter pub get
3. Restart app
4. Previous themes restored
```

**Option 2: Reset Themes**
```
1. Keep upgraded module
2. Clear saved theme preferences
3. Reset all users to default theme
4. Allow users to re-customize
```

**Option 3: Manual Fix**
```
1. Keep upgraded module
2. Manually fix problematic themes
3. Update theme JSON files
4. Re-deploy themes
```

---

## Summary

**Migration Best Practices**:

1. **Version All Schemas**: Every theme has schema version
2. **Provide Migrations**: Auto-migrate old themes to new schemas
3. **Validate After Migration**: Ensure migrated themes are valid
4. **Deprecate Before Removing**: Give users time to adapt
5. **Document Breaking Changes**: Clear communication in CHANGELOG
6. **Test Migrations**: Comprehensive migration testing
7. **Provide Fallbacks**: Always have safe default if migration fails
8. **Gradual Upgrades**: Allow phased adoption of new versions

**Migration Checklist**:

- [ ] Read CHANGELOG before upgrading
- [ ] Update theming module version
- [ ] Run app, check migration logs
- [ ] Test all theme presets
- [ ] Test custom themes
- [ ] Fix deprecated token usage
- [ ] Update app code if needed
- [ ] Manual QA on all platforms
- [ ] Deploy with rollback plan
- [ ] Monitor for issues

Proper migration planning ensures smooth theme evolution without breaking user customizations or app functionality.

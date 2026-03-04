# Version 1.1 Update Summary

## Changes Implemented

### 1. Notifications Enabled by Default ✅
- **What**: Notifications are now enabled by default for all users
- **One-time Alert**: Users updating from v1.0 or new users will see a one-time alert explaining that notifications are enabled and can be customized in Settings
- **Implementation**:
  - Added version tracking in `SpeakingWithMyselfApp.swift`
  - Alert appears 4 seconds after splash screen (after app launch)
  - Uses `@AppStorage` to track if user has seen the notification update message
  - Automatically enables notifications on first launch after update

### 2. Second "Time to Write" Notification ✅
- **What**: Added optional second daily notification to remind users to write their reflection
- **Default**: Disabled by default (user must opt-in)
- **Default Time**: 8:00 PM (20:00)
- **Implementation**:
  - Added `writeReminderEnabled` and `writeReminderTime` properties to `NotificationManager`
  - New notification identifier: "writeReminder"
  - Separate toggle and time picker in Settings
  - Independent scheduling from the daily question notification

### 3. Question Advancement Mode ✅
- **What**: Added setting to control how questions advance
- **Modes**:
  - **Default (Off)**: Questions advance daily regardless of whether answered
  - **Retain Until Completed (On)**: Same question stays until user provides a response
- **Implementation**:
  - Added `retainQuestionUntilCompleted` property to `DataStore`
  - Modified `setupTodaysPrompt()` to check if yesterday's question was answered
  - If unanswered and retain mode is on, carries forward the same question with same day number/label
  - Persisted in UserDefaults under "retainQuestionUntilCompleted" key

### 4. History Display Improvements ✅
- **What**: Fixed history display to show when user actually answered, not when prompt was created
- **Why**: With retain mode, a question could be created on multiple dates before being answered
- **Implementation**:
  - History now shows "Answered [date]" using `respondedAt` field
  - Provides clear context: when they actually completed the reflection
  - More meaningful for users looking back at their journey

### 5. Text Editor UX Improvements ✅
- **What**: Fixed keyboard/save button visibility when typing
- **Problem**: Save button would go below the fold when keyboard appeared
- **Solution**:
  - Increased text editor min height to 200px (from 150px)
  - Added max height of 400px to prevent excessive expansion
  - Better balance between writing space and button visibility

### 6. Progression-Based System Refactor ✅
- **What**: Decoupled question progression from calendar dates
- **Why**: Users wanted to "power through" questions without date manipulation
- **Implementation**:
  - Added `currentProgressionDay` property (1-7) independent of dates
  - New `advanceToNextQuestion()` method advances progression, not dates
  - Migration logic for existing users preserves their current state
  - Banner now shows "Question X of 7" when working ahead
  - Dev mode still uses simulated dates for testing
  - All existing prompts and responses preserved

## Data Preservation

### Critical Safeguards
All changes preserve existing user data:
- ✅ No changes to existing UserDefaults keys
- ✅ All new settings use new keys (no conflicts)
- ✅ Existing prompts and responses remain intact
- ✅ No data model changes to `DailyPrompt` or `WeeklyTopic`
- ✅ Backward compatible with v1.0 data

### UserDefaults Keys
**Existing (unchanged)**:
- `savedPrompts` - All user responses
- `currentTopic` - Current topic selection
- `weekStartDate` - Week start tracking
- `corePromptIndex` - Topic prompt rotation
- `simulatedDate` - Dev tools date simulation
- `draftResponse` - Auto-saved draft text
- `reminderEnabled` - Original notification toggle
- `reminderTime` - Original notification time
- `hasCompletedOnboarding` - Onboarding status

**New (v1.1)**:
- `writeReminderEnabled` - Second notification toggle
- `writeReminderTime` - Second notification time
- `retainQuestionUntilCompleted` - Question advancement mode
- `hasSeenNotificationUpdate` - One-time alert tracking
- `appVersion` - Version tracking for migrations
- `currentProgressionDay` - Progression counter (1-7) independent of dates

## Files Modified

1. **NotificationManager.swift**
   - Added write reminder properties and methods
   - Added `scheduleWriteReminder()` function
   - Added enable/disable/update methods for write reminder

2. **DataStore.swift**
   - Added `retainQuestionUntilCompleted` property
   - Added load/save methods for retain setting
   - Modified `setupTodaysPrompt()` to respect retain mode

3. **SettingsView.swift**
   - Added second notification section with toggle and time picker
   - Added question advancement section with toggle
   - Updated `TimePickerSheet` to accept custom title
   - Added footer text explaining each setting

4. **SpeakingWithMyselfApp.swift**
   - Added version tracking
   - Added one-time notification alert
   - Added `checkForUpdates()` function
   - Auto-enables notifications for new/updating users

5. **HistoryView.swift**
   - Updated to show "Answered [date]" instead of prompt creation date
   - Uses `respondedAt` field for more accurate history display

6. **TodayView.swift**
   - Increased text editor min height to 200px
   - Added max height of 400px
   - Improved keyboard/save button visibility

7. **PROJECT_NOTES.md**
   - Added data preservation guidelines
   - Added version history section
   - Documented v1.1 changes

## Testing Checklist

### Before Release
- [ ] Build succeeds without errors
- [ ] Test with existing v1.0 data (simulate upgrade)
- [ ] Verify all existing responses are preserved
- [ ] Test notification scheduling for both reminders
- [ ] Test retain question mode (answer/skip scenarios)
- [ ] Verify one-time alert shows only once
- [ ] Test Settings UI for all new options
- [ ] Verify default notification time (9:00 AM)
- [ ] Verify default write reminder time (8:00 PM)
- [ ] Test on physical device (notifications require real device)

### User Experience
- [ ] Alert message is clear and helpful
- [ ] Settings are easy to find and understand
- [ ] Notification times can be customized
- [ ] Retain mode works as expected
- [ ] History shows "Answered" dates correctly
- [ ] Text editor and save button remain visible when typing
- [ ] No data loss during update

## Next Steps

1. Test thoroughly with simulated v1.0 data
2. Update version number in Xcode project (1.0 → 1.1)
3. Update build number
4. Test on physical device
5. Submit to App Store Connect
6. Update release notes for App Store

## Release Notes (for App Store)

**What's New in Version 1.1**

• Notifications are now enabled by default to help you build a daily reflection habit
• Added optional "Time to Write" reminder for a second daily nudge
• New setting to keep questions until you answer them (instead of advancing daily)
• History now shows when you actually answered each question
• Improved text editor experience with better keyboard visibility
• All your existing reflections and progress are preserved

We're committed to helping you show up for yourself every day. Thank you for being part of this journey!

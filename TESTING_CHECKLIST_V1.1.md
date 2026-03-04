# Version 1.1 Testing Checklist

## Critical Data Preservation Tests

### Test 1: Existing User Migration
- [ ] Install v1.0, create responses for days 1-3
- [ ] Update to v1.1
- [ ] Verify all 3 responses still exist in History
- [ ] Verify progression counter set correctly (should be 4)
- [ ] Verify can continue from day 4

### Test 2: New User Experience
- [ ] Fresh install of v1.1
- [ ] Complete onboarding
- [ ] Verify notification alert appears after splash
- [ ] Verify notifications are enabled by default
- [ ] Select topic and answer day 1
- [ ] Verify response saves correctly

## Feature Tests

### Test 3: Notifications
- [ ] Verify daily question notification scheduled (check Settings)
- [ ] Enable "Time to Write" notification
- [ ] Verify both notifications scheduled independently
- [ ] Change notification times
- [ ] Disable notifications
- [ ] Re-enable notifications

### Test 4: Retain Question Mode
- [ ] Enable "Retain Question Until Completed"
- [ ] Skip a day without answering
- [ ] Verify same question appears next day
- [ ] Answer the question
- [ ] Verify progression advances to next question
- [ ] Disable retain mode
- [ ] Verify normal daily advancement resumes

### Test 5: Next Question Feature
- [ ] Answer day 1 question
- [ ] Tap "Next Question"
- [ ] Verify banner shows "Question 2 of 7"
- [ ] Verify day 2 question appears
- [ ] Answer and advance through days 2-6
- [ ] Verify "Next Question" disappears on day 7
- [ ] Verify can still switch topics

### Test 6: History Display
- [ ] Create responses on different days
- [ ] Use "Next Question" to work ahead
- [ ] Check History view
- [ ] Verify shows "Answered [date]" for each entry
- [ ] Verify grouped by topic correctly
- [ ] Tap entry to view detail

### Test 7: Insights Display
- [ ] Complete several days
- [ ] Check Insights view
- [ ] Verify 7-day progress shows numerals 1-7
- [ ] Verify completed days show green checkmarks
- [ ] Verify current day highlighted in indigo
- [ ] Verify stats accurate (reflections, topics, words)

## Edge Cases

### Test 8: Topic Switching
- [ ] Start topic, answer day 3
- [ ] Switch to different topic
- [ ] Verify progression resets to day 1
- [ ] Verify old responses preserved in History
- [ ] Return to original topic
- [ ] Verify can select different starting prompt

### Test 9: Text Editor UX
- [ ] Start writing a long response
- [ ] Verify text editor expands
- [ ] Verify Save button stays visible
- [ ] Verify keyboard doesn't hide button
- [ ] Save response
- [ ] Verify draft cleared

### Test 10: Dev Tools (if accessible)
- [ ] Open Dev Tools from Menu
- [ ] Set simulated date
- [ ] Verify banner shows "Dev Mode: [date]"
- [ ] Reset to real date
- [ ] Verify banner shows progression instead

## Security & Privacy

### Test 11: Data Storage
- [ ] Verify all data stored locally (no network calls)
- [ ] Check UserDefaults for sensitive data
- [ ] Verify no PII in logs
- [ ] Verify notifications don't expose content

### Test 12: Permissions
- [ ] Deny notification permission
- [ ] Verify app still functions
- [ ] Grant permission later
- [ ] Verify notifications work

## Performance

### Test 13: App Launch
- [ ] Cold launch time < 3 seconds
- [ ] Splash screen displays correctly
- [ ] No crashes on launch
- [ ] Smooth transition to main view

### Test 14: Large Data Sets
- [ ] Create 50+ responses
- [ ] Verify History scrolls smoothly
- [ ] Verify Insights calculates correctly
- [ ] Verify no performance degradation

## Regression Tests

### Test 15: Core Functionality
- [ ] Select topic
- [ ] Answer question
- [ ] Edit response
- [ ] View history
- [ ] Check insights
- [ ] Switch topics
- [ ] All features work as expected

## Sign-Off

- [ ] All critical tests passed
- [ ] No data loss observed
- [ ] All new features working
- [ ] No regressions found
- [ ] Ready for App Store submission

**Tested by:** _________________
**Date:** _________________
**Build:** v1.1 (Build ___)

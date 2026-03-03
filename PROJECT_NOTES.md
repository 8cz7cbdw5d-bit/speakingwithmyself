# Speaking with Myself - Project Notes

## ⚠️ IMPORTANT: Project Structure
There are TWO folders in this workspace:

1. **`SpeakingWithMyself/`** - DEPRECATED/OLD VERSION
   - This was the original attempt that had issues
   - DO NOT USE for new development
   - Keep for reference only

2. **`SpeakingWithMyselfV1/`** - ACTIVE/PRODUCTION VERSION ✅
   - This is the version submitted to App Store
   - All new development should happen here
   - This is the version in the GitHub repo

**When working on features, always use `SpeakingWithMyselfV1/`**

## Git Repository
- **GitHub:** https://github.com/8cz7cbdw5d-bit/speakingwithmyself
- **GitHub Pages (Privacy Policy):** https://8cz7cbdw5d-bit.github.io/speakingwithmyself
- **Local Path:** `SpeakingWithMyselfV1/` (NOT `SpeakingWithMyself/`)

## App Store Connect
- **Bundle ID:** com.speakingwithmyself.app
- **Development Team ID:** 766LTFPW27
- **First Submission:** February 2, 2026
- **Version:** 1.0 (Build 1)
- **Status:** Waiting for Review

## Project Structure (V1)
```
SpeakingWithMyselfV1/
├── SpeakingWithMyselfV1/           # Main app code
│   ├── SpeakingWithMyselfApp.swift # App entry point
│   ├── ContentView.swift           # Main navigation
│   ├── Assets.xcassets/            # Images, icons, colors
│   ├── Data/
│   │   └── DataStore.swift         # Core data management
│   ├── Models/
│   │   └── Models.swift            # Data structures
│   ├── Services/
│   │   └── NotificationManager.swift
│   └── Views/                      # All UI screens
│       ├── TodayView.swift         # Daily prompt screen
│       ├── HistoryView.swift       # Past entries
│       ├── InsightsView.swift      # Analytics
│       ├── MenuView.swift          # Main menu
│       ├── OnboardingView.swift    # First-time setup
│       ├── PromptDetailView.swift  # Individual prompt
│       ├── SettingsView.swift      # App settings
│       ├── TopicPickerView.swift   # Topic selection
│       └── DevToolsView.swift      # Debug tools
├── docs/
│   └── index.html                  # Privacy policy (GitHub Pages)
├── PrivacyPolicy.md                # Privacy policy source
└── PROJECT_NOTES.md                # This file
```

## Key Files
- Privacy Policy: `docs/index.html` (hosted via GitHub Pages)
- App Icon: `SpeakingWithMyselfV1/Assets.xcassets/AppIcon.appiconset/AppIcon.png`
- Data Storage: All local via UserDefaults (no cloud/server)

## Build & Archive Notes
- Use "Any iOS Device (arm64)" destination for archiving
- Archive via Product → Archive in Xcode
- Distribute via App Store Connect → Upload
- App uses NO custom encryption (standard iOS only)
- No device registration needed for App Store distribution

## App Details
- **Category:** Lifestyle (or Health & Fitness)
- **Age Rating:** 4+ (no mature content)
- **Data Collection:** None - all data stored locally on device
- **Contact:** citizen.e@gmail.com
- **Support URL:** https://8cz7cbdw5d-bit.github.io/speakingwithmyself

## App Features
- 10 weekly topics (Autonomy, Competence, Relatedness, Growth Mindset, Strengths, Resilience, Purpose, Gratitude, Focus, Creativity)
- 7-day reflection cycle per topic (Open, Deepen, Distill, Imagine, Begin, Notice, Carry)
- Local-only storage (privacy-first)
- Daily notifications (optional)
- History and insights views
- Dev tools for testing/debugging

## Troubleshooting History
- Exit code 70 was caused by trying ad-hoc/development export without registered devices
- Solution: Use App Store distribution instead (doesn't require device registration)
- Manual signing can be used if automatic signing fails

## Next Steps / Future Features
- (Add feature ideas here as you work on them)

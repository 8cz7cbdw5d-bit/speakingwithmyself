# Speaking with Myself - Project Notes

## Git Repository
- **GitHub:** https://github.com/8cz7cbdw5d-bit/speakingwithmyself
- **GitHub Pages (Privacy Policy):** https://8cz7cbdw5d-bit.github.io/speakingwithmyself

## App Store Connect
- **Bundle ID:** com.speakingwithmyself.app
- **Development Team ID:** 766LTFPW27
- **First Submission:** February 2, 2026
- **Version:** 1.0 (Build 1)

## Key Files
- Privacy Policy: `docs/index.html` (hosted via GitHub Pages)
- App Icon: `Assets.xcassets/AppIcon.appiconset/AppIcon.png`

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

## Troubleshooting History
- Exit code 70 was caused by trying ad-hoc/development export without registered devices
- Solution: Use App Store distribution instead (doesn't require device registration)
- Manual signing can be used if automatic signing fails

# CricScore (Cricket Scorer)

Local, offline-first cricket scoring app built with Flutter.

## Features

- Live match scoring (runs, wickets, extras, overs)
- Persist matches locally using **Hive**
- Match list + resumable sessions (home screen reads from persisted data)
- Scorecard screen with batting + bowling breakdown
- Scorecard export as **PNG** images
  - Export is gated behind a **rewarded ad**
  - Exports **1st innings** and **2nd innings** PNGs
  - PNGs can be saved and shared to social apps via the system share sheet

## Tech Stack

- Flutter
- Riverpod (state management)
- Hive (local storage)
- Rewarded Ads (Google Mobile Ads)
- PNG export (widget rendering to image)
- Share sheet (share_plus)

## Setup

### 1) Flutter

- Flutter SDK: see `flutter --version`

### 2) Ads (Rewarded)

This project includes rewarded ad gating for scorecard export.

For Android Play Store builds, configure AdMob IDs like this:

1. **Rewarded ad unit id** (Dart define)
   - Build with:
     `--dart-define=ADMOB_REWARDED_AD_UNIT_ID=YOUR_REWARDED_AD_UNIT_ID`
2. **AdMob application id** (Gradle property)
   - Pass at build time:
     `-PadmobAppId=YOUR_ADMOB_APP_ID`
   - (Or set `admobAppId` in `android/gradle.properties`.)

### 3) Run

```bash
flutter pub get
flutter run
```

## Android Build

Debug build:

```bash
flutter build apk --debug
```

Release build:

```bash
flutter build apk --release
```

Play Store upload (Android App Bundle):

```bash
flutter build appbundle --release -PadmobAppId=YOUR_ADMOB_APP_ID --dart-define=ADMOB_REWARDED_AD_UNIT_ID=YOUR_REWARDED_AD_UNIT_ID
```

For Play Store / release signing, configure Gradle signing as per the Flutter Android guide.

## Notes

- Score export is implemented as a render-to-image workflow and may require platform storage permissions depending on the chosen target/OS version.


# Android release verification

## Build identity

Task Planner uses the development application ID `com.example.task_planner`. The namespace remains `com.example.task_planner` so the Kotlin entry point stays stable. Set `TASK_PLANNER_APPLICATION_ID` or Gradle property `plannerApplicationId` to the existing published ID or a unique owner-approved ID before packaging a release. Changing an installed ID creates a separate Android app with separate local storage.

The candidate version is **1.0.0 (2)**. Android package metadata drives the version shown in Settings. Check the highest uploaded version code and record the release commit before uploading. The workspace had no Git commit at the start of this audit.

The app requires API 24, targets API 36 or newer if the Flutter default increases, and compiles with API 37 or newer. API 37 is required by the installed notification plugin. The project uses AGP 9.1.0, Kotlin 2.4.0, Java 17 bytecode and core library desugaring. Google Play currently requires API 36 or newer for standard mobile submissions. [Target API policy](https://support.google.com/googleplay/android-developer/answer/11926878?hl=en)

## Signing

Use the established upload key for any existing listing. For a new listing, the owner can create a dedicated key in a private location using interactive keytool prompts. Keep encrypted backups of the keystore and credentials with restricted access and record the upload certificate fingerprint separately.

Configure an ignored `android/key.properties` with `storeFile`, `storePassword`, `keyAlias`, and `keyPassword`, or supply the values through `TASK_PLANNER_UPLOAD_STORE`, `TASK_PLANNER_UPLOAD_STORE_PASSWORD`, `TASK_PLANNER_UPLOAD_ALIAS`, and `TASK_PLANNER_UPLOAD_KEY_PASSWORD`. Use an absolute keystore path or a path relative to `android/`. Release packaging requires these inputs and rejects the standard debug key. Keep CI secrets scoped to approved release jobs. [Flutter Android signing documentation](https://docs.flutter.dev/deployment/android)

## Verification commands

```sh
flutter clean
flutter pub get
dart run build_runner build
dart format --output=none --set-exit-if-changed .
flutter analyze
flutter test
flutter build apk --debug
```

With signing and the published HTTPS privacy policy configured, build the release APK and bundle. Inject the production application ID and signing configuration through the environment before invoking Flutter.

```sh
flutter build apk --release --dart-define="PLANNER_PRIVACY_URL=$TASK_PLANNER_PRIVACY_URL"
flutter build appbundle --release --dart-define="PLANNER_PRIVACY_URL=$TASK_PLANNER_PRIVACY_URL"
apksigner verify --verbose --print-certs build/app/outputs/flutter-apk/app-release.apk
jarsigner -verify build/app/outputs/bundle/release/app-release.aab
```

Substitute the approved policy URL in the build commands. Confirm the certificate matches the upload key. Inspect both artifacts for the application ID, version, manifest permissions, 16 KB alignment and included ABIs. Verify the installed build on Android before distribution. [Native page-size guidance](https://developer.android.com/guide/practices/page-sizes)

## Device test matrix

Record device model, Android version, build version and certificate, expected and observed behavior, and redacted failure logs. Cover API 24–32, API 33+ notification permissions, and a 16 KB Android 15+ device.

- Open an existing v1 or v2 installation and upgrade in place. Confirm the hierarchy, deadlines, recurrence history, and preferences persist after app and device restart.
- Test creating, editing, completing, reassigning and deleting tasks, plus both goal deletion policies. Repeat with airplane mode enabled.
- Test foreground, background, cold notification taps, denied permission, a deleted task payload, timezone changes, and reboot restoration. Treat scheduled state and delivered state separately.
- Review compact and large displays, landscape, system dark mode, TalkBack, enlarged text, keyboard insets, and long labels. Gather profile-mode startup, frame-time, memory, and scroll measurements.
- Capture actual release-build screenshots and review the store artwork and owner contact details.

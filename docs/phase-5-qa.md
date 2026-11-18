# Task Planner Phase 5 QA report

Evidence recorded on 18 November 2026.

## 1. Executive summary

The project has a verified host regression suite, a release manifest audit, and an Android development build. Production distribution remains blocked by signing, app identity, and Android runtime verification.

## 2. Codebase audit

Release had a debug-signing fallback and a placeholder application ID. Packaging now checks for an owner-approved application ID and upload key. Long task lists now render as individual lazy page rows. Reminder reconciliation cancels stale alarms before filling the available slots, and Android alerts use generic text.

## 3. Automated testing

`flutter clean`, `flutter pub get`, Drift code generation, Dart formatting, and `flutter analyze --no-pub` completed. The full Flutter suite passed **57 tests**. New tests cover 10,000-row rendering, enlarged landscape and tablet UI, installed version display, recurrence split rollback, and reminder capacity, restart, and timezone reconciliation.

## 4. Database reliability

Schema v2 remains in use. Tests upgrade the actual v1 schema and preserve foreign keys, dates, deadlines and task links. Other tests close and reopen file-backed SQLite, check calculations and constraints, and inject failures into hierarchy deletion and recurrence splitting to verify rollback.

## 5. Performance

Host fixture measured on Linux x86-64 with an Intel Core i7-8665U, Flutter 3.47.5 and Dart 3.13.4. Times are medians of five warm samples using in-memory SQLite. Filtering times exclude loading the candidate rows.

| Persisted tasks | Seven-day query before → after | Text filter and sort before → after |
|---:|---:|---:|
| 100 | 1.50 → 1.40 ms | 0.68 → 0.18 ms |
| 1,000 | 4.01 → 2.46 ms | 2.95 → 0.78 ms |
| 10,000 | 9.74 → 9.55 ms | 16.11 → 3.28 ms |

Search normalizes the query once and avoids repeat whitespace processing across candidate text. The Daily Planner widget test instantiated fewer than 50 task rows with 10,000 tasks on one date, including after scrolling. These are host measurements and do not establish Android startup, frame-time, memory, or scrolling performance.

## 6. UI and accessibility

Widget coverage includes 320 × 640 portrait, 640 × 320 landscape, and 1024 × 768 tablet at 200% text scaling. The privacy dialog now scrolls its heading and body on short screens. Task rows retain labeled actions and independent completion controls. TalkBack and on-device contrast and touch checks remain open.

## 7. Security and privacy

The merged release manifest excludes Internet permission and cleartext traffic. It permits optional notifications, vibration, and reboot restoration, plus AndroidX's app-scoped signature permission. The launcher is exported as required. AndroidX's exported profile installer receiver requires the platform `DUMP` permission, and the notification receivers are non-exported. The release configuration disables automatic backup and excludes planner storage from backup and transfer rules. The audit inspected source and manifests. Runtime traffic and device-vendor backup behavior were outside the host test coverage.

## 8. Release configuration

Candidate version **1.0.0 (2)**. Development application ID `com.example.task_planner`. Minimum API 24, target API 36, compile API 37. AGP 9.1.0, Gradle 9.3.1, Kotlin 2.4.0 and Java 17 bytecode. Release shrinking keeps the notification drawable. Release packaging requires separate upload signing inputs. The local workspace has no Git commit or hosted CI configuration.

## 9. Build artifacts

Gradle merged the release manifest and resources successfully. `flutter build apk --release` and `flutter build appbundle --release` both stopped at the missing approved-ID check. A separate release check with a test-only ID stopped at missing upload signing. No production APK or AAB was generated.

The development APK is `build/app/outputs/flutter-apk/app-debug.apk`. Android build tools verified the debug APK Signature Scheme v2 signature, package metadata, and 16 KB ZIP alignment. ELF LOAD segment alignment passed for all seven packaged 64-bit libraries. The APK includes arm64-v8a, armeabi-v7a, and x86_64. SHA-256 is `5e36374170089daa4f91c2019f0e8d454ff52368e94603e026935e8ec0fb84b7`.

## 10. Device verification

No physical Android device was attached. A fresh Pixel 8 profile using the installed Android API 37.2 x86-64 16 KB system image crashed before ADB could install the app. Installation, Android startup, airplane-mode behavior, reboot restoration, runtime permissions, and actual notification delivery remain unverified.

## 11. Play Store readiness

The store listing, changelog, privacy draft, and release runbook are prepared. The owner still needs to confirm the package ID, upload key, privacy URL and contact, approved artwork, and actual screenshots. The publisher must complete the account-specific Play Console declarations and any applicable closed testing. [Play review requirements](https://support.google.com/googleplay/android-developer/answer/9859455?hl=en)

## 12. Known limitations

Android can delay or suppress inexact alarms. The app keeps up to 64 pending reminders and fills a rolling 30-day recurrence window when it reconciles. The debug APK is a QA artifact. Signed release verification and device profiling remain open.

## 13. Final release status

**Blocked.** Release signing and owner-approved identity are unavailable, and a release build has yet to be installed and verified on Android.

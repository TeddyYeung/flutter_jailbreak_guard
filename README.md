# 🛡️ flutter_jailbreak_guard

[![pub version](https://img.shields.io/pub/v/flutter_jailbreak_guard)](https://pub.dev/packages/flutter_jailbreak_guard)
[![pub points](https://img.shields.io/pub/points/flutter_jailbreak_guard)](https://pub.dev/packages/flutter_jailbreak_guard/score)
[![pub likes](https://img.shields.io/pub/likes/flutter_jailbreak_guard)](https://pub.dev/packages/flutter_jailbreak_guard/score)
![SPM](https://img.shields.io/badge/Swift_Package_Manager-supported-brightgreen)
![CocoaPods](https://img.shields.io/badge/CocoaPods-supported-brightgreen)
![Platforms](https://img.shields.io/badge/platforms-iOS_|_Android-blue)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)

**Jailbreak and root detection for Flutter, with Swift Package Manager support.**
A modern replacement for `flutter_jailbreak_detection_plus` that gives the same detection results.

- ✅ **Swift Package Manager and CocoaPods** on iOS
- ✅ **Same results as flutter_jailbreak_detection_plus**: the same engines and the same fallback values
- ✅ **Fail-closed**: a missing result reports the device as unsafe
- ✅ **No main-thread blocking on Android**: root checks run on a background task queue
- ✅ **Your choice of iOS engine license**: IOSSecuritySuite 1.9.x (BSD-2) or 2.x (EULA). See [License](#license).
- ✅ **Tested**: Dart unit tests, a Kotlin unit test, and integration tests

## Contents

- [Quick start](#quick-start)
- [API](#api)
- [How it works](#how-it-works)
- [Why this package](#why-this-package)
- [Comparison with other packages](#comparison-with-other-packages)
- [Migration from flutter_jailbreak_detection_plus](#migration-from-flutter_jailbreak_detection_plus)
- [Behavior](#behavior)
- [Limitations](#limitations)
- [License](#license)

## Quick start

**1. Install the package.**

```bash
flutter pub add flutter_jailbreak_guard
```

**2. Check the device.**

```dart
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard.dart';

Future<bool> isUnsafeDevice() async {
  try {
    return await FlutterJailbreakGuard.isJailbroken;
  } on PlatformException {
    return true;
  }
}
```

**3. iOS only: add the jailbreak app URL schemes to `ios/Runner/Info.plist`.**

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
    <string>undecimus</string>
    <string>sileo</string>
    <string>zbra</string>
    <string>filza</string>
</array>
```

If you skip step 3, iOS returns `false` for these URL checks. The other checks still run.

## API

| API | Returns `true` when | iOS | Android |
|---|---|---|---|
| `FlutterJailbreakGuard.isJailbroken` | The device is jailbroken or rooted | `IOSSecuritySuite.amIJailbroken()` | `RootBeer.isRooted` |
| `FlutterJailbreakGuard.isDeveloperMode` | iOS: the app runs in the simulator<br>Android: developer options are on | `IOSSecuritySuite.amIRunInEmulator()` | `Settings.Global.DEVELOPMENT_SETTINGS_ENABLED` |

On iOS, `isDeveloperMode` does not read the iOS Developer Mode setting.

## How it works

```text
FlutterJailbreakGuard.isJailbroken
  │
  ├── iOS      ──▶ IOSSecuritySuite.amIJailbroken()   main thread
  │
  └── Android  ──▶ RootBeer(context).isRooted          background task queue
                    (file checks, su, build tags)

Native result is null  ──▶ true  (fail-closed)
Native call fails      ──▶ PlatformException
```

## Why this package

flutter_jailbreak_detection_plus is a common choice for jailbreak and root detection. It did not keep up with the current Flutter build tools.

| | flutter_jailbreak_detection_plus 1.10.7 | flutter_jailbreak_guard |
|---|---|---|
| iOS package manager | CocoaPods only | 🆕 Swift Package Manager and CocoaPods |
| iOS plugin code | Swift with an Objective-C bridge | Swift only |
| Android Gradle Plugin | 8.5.1 | 🆕 9.0.1 |
| Kotlin | 1.9.10 | 🆕 2.3.20 |
| Android compileSdk | 34 | 🆕 36 |
| Gradle script | Groovy | Kotlin DSL |
| Android thread | Platform thread | 🆕 Background task queue |
| Tests | None | 🆕 Dart, Kotlin, integration |

The goals of this package:

1. **Current iOS builds**: Flutter builds iOS plugins with Swift Package Manager. Without SPM support, a plugin keeps the app on CocoaPods.
2. **Current Android builds**: The plugin uses the current Android Gradle Plugin, Kotlin, and compileSdk.
3. **No change in results**: The plugin keeps the detection logic and fallback values of flutter_jailbreak_detection_plus. You change only the import and the method names.
4. **One package with all of these**: Other packages have some of these features. No other package in the comparison has all of them.

## Comparison with other packages

flutter_jailbreak_guard is the only package in this list that has all six items.

| Package | iOS SPM | Same results as `_plus` | Fail-closed | Android checks off the main thread | BSD-licensed iOS engine possible | Tests in the package |
|---|:---:|:---:|:---:|:---:|:---:|:---:|
| 🛡️ **flutter_jailbreak_guard** | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| [flutter_jailbreak_detection_plus](https://pub.dev/packages/flutter_jailbreak_detection_plus) | ❌ | — | ✅ | ❌ | ✅ | ❌ |
| [flutter_jailbreak_detection](https://pub.dev/packages/flutter_jailbreak_detection) | ❌ | ✅ | ✅ | ❌ | ✅ | ❌ |
| [root_jailbreak_guard](https://pub.dev/packages/root_jailbreak_guard) | ✅ | ❌ | ✅ | ❌ | ❌ | ❌ |
| [jailbreak_root_detection](https://pub.dev/packages/jailbreak_root_detection) | ✅ | ❌ | ❌ | ✅ | ✅ | ❌ |
| [safe_device](https://pub.dev/packages/safe_device) | ✅ | ❌ | ❌ | ❓ | — | ✅ |
| [freerasp](https://pub.dev/packages/freerasp) | ✅ | ❌ | — | — | — | ❌ |

✅ Yes · ❌ No · ❓ Not checked · — Not applicable

- **Same results as `_plus`**: The package calls the same engine methods as flutter_jailbreak_detection_plus. You can migrate without a change in detection results.
- **Fail-closed**: If the native result is missing, the package reports the device as unsafe.
- **BSD-licensed iOS engine possible**: The app can use IOSSecuritySuite 1.9.x, which has the BSD-2 license. IOSSecuritySuite 2.x has a paid EULA for larger companies.
- **Tests in the package**: The package published on pub.dev contains tests.

<details>
<summary><b>Details</b>: versions, engines, and minimum platforms</summary>

Data comes from the source code of the latest version on pub.dev, checked on 2026-10-15.

| Package | Version | iOS engine | Android engine | Min iOS / Android API | Fallback when the result is missing | Android thread |
|---|---|---|---|---|---|---|
| **flutter_jailbreak_guard** | 0.2.1 | IOSSecuritySuite 1.9.10 to 2.x | RootBeer 0.1.2 | 13.0 / 24 | `true` | Background task queue |
| flutter_jailbreak_detection_plus | 1.10.7 (2025-10) | IOSSecuritySuite, no version pin | RootBeer 0.1.1 | 10.0 / 17 | `true` | Platform thread |
| flutter_jailbreak_detection | 1.10.0 (2023-01) | IOSSecuritySuite, no version pin | RootBeer 0.1.0 | 10.0 / 17 | `true` | Platform thread |
| root_jailbreak_guard | 1.1.1 (2026-09) | IOSSecuritySuite 2.2+ | RootBeer 0.1.2 | 13.0 / 21 | `true` | Platform thread |
| jailbreak_root_detection | 1.2.3 (2026-08) | IOSSecuritySuite 1.9.x | RootBeer 0.1.1 and custom checks | 11.0 / 21 | `false` | Coroutine (`Dispatchers.Default`) |
| safe_device | 1.4.1 (2026-07) | DTTJailbreakDetection 0.4.0 and custom checks | RootBeer 0.1.1 and custom checks | 12.0 / 21 | `false` | Not checked |
| freerasp | 8.2.4 (2026-10) | Talsec SDK | Talsec SDK | 13.0 / 23 | Not applicable (callback API) | Not applicable |

</details>

### Difference from root_jailbreak_guard

root_jailbreak_guard has the same API as flutter_jailbreak_detection_plus, but its checks are different.

| Check | flutter_jailbreak_guard | root_jailbreak_guard |
|---|---|---|
| iOS jailbreak | `amIJailbroken()` | `amIJailbroken()` or `amIDebugged()` |
| iOS developer mode | `amIRunInEmulator()` | `amIRunInEmulator()` or `amIDebugged()` |
| Android root | `isRooted` | `isRooted` or `isRootedWithBusyBoxCheck` |

root_jailbreak_guard returns `true` for jailbreak when a debugger is attached to the iOS app. This occurs when you run the app from Xcode. flutter_jailbreak_guard returns the same result as flutter_jailbreak_detection_plus.

### When to use another package

- If you need more signals, such as Frida, debugger, tampering, or mock location, use jailbreak_root_detection, safe_device, or freerasp.
- If you need a full runtime protection SDK with threat callbacks, use freerasp.
- If your app supports iOS earlier than 13.0 or Android API earlier than 24, this package does not support it.

## Migration from flutter_jailbreak_detection_plus

```diff
 dependencies:
-  flutter_jailbreak_detection_plus: ^1.10.7
+  flutter_jailbreak_guard: ^0.2.0
```

```diff
-import 'package:flutter_jailbreak_detection_plus/flutter_jailbreak_detection_plus.dart';
+import 'package:flutter_jailbreak_guard/flutter_jailbreak_guard.dart';

-final jailbroken = await FlutterJailbreakDetectionPlus.jailbroken;
-final developerMode = await FlutterJailbreakDetectionPlus.developerMode;
+final jailbroken = await FlutterJailbreakGuard.isJailbroken;
+final developerMode = await FlutterJailbreakGuard.isDeveloperMode;
```

The detection engines and the fallback values are the same.

## Behavior

### Failure handling

| Native result | Return value |
|---|---|
| `true` or `false` | The same value |
| `null` | `true` |
| The call fails | Throws `PlatformException` |

The app decides whether a failed check blocks the user.

### Threading

- iOS runs the checks on the main thread. `IOSSecuritySuite.amIJailbroken()` calls `UIApplication.shared.canOpenURL`.
- Android runs the checks on a background task queue. `RootBeer.isRooted` reads files and runs `su`.

## Limitations

- On-device checks cannot detect every jailbreak or root. A user with full control of the device can hide it from the app.
- Do not use this package as the only protection for high-risk actions. Add server-side checks.
- On iOS, `isDeveloperMode` reports only the simulator.

## License

This package is available under the [MIT License](LICENSE).

### iOS engine license

The iOS engine, [IOSSecuritySuite](https://github.com/securing/IOSSecuritySuite), changed its license in version 2.0.

| IOSSecuritySuite | License | Cost |
|---|---|---|
| 1.9.10 to 1.9.11 | [BSD-2](https://github.com/securing/IOSSecuritySuite/blob/1.9.11/LICENSE) | Free |
| 2.0 and later | [EULA](https://github.com/securing/IOSSecuritySuite/blob/master/LICENSE) | Free only for a company that employs no more than 100 people. Larger companies and companies that sell apps with the library need a paid plan. |

> ⚠️ **Important**: This package accepts both versions. Without a pin, the app gets the latest 2.x version. Read the EULA before you ship your app.

To use the BSD-licensed 1.9.11, pin it in your app.

**CocoaPods**: add the pin to `ios/Podfile`, then run `pod update IOSSecuritySuite` in the `ios` folder.

```ruby
target 'Runner' do
  pod 'IOSSecuritySuite', '1.9.11'
  # ...
end
```

**Swift Package Manager**:

1. Open `ios/Runner.xcworkspace` in Xcode.
2. Select the **Runner** project, then open **Package Dependencies**.
3. Add `https://github.com/securing/IOSSecuritySuite`.
4. Set **Dependency Rule** to **Exact Version** `1.9.11`.
5. Add the `IOSSecuritySuite` library to the **Runner** target.

# flutter_jailbreak_guard

Detects jailbroken iOS devices and rooted Android devices.

| Platform | Engine | Package manager |
|---|---|---|
| iOS 13.0+ | [IOSSecuritySuite](https://github.com/securing/IOSSecuritySuite) 2.2+ | Swift Package Manager, CocoaPods |
| Android API 24+ | [RootBeer](https://github.com/scottyab/rootbeer) 0.1.2 | Gradle |

## Usage

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

| API | iOS | Android |
|---|---|---|
| `isJailbroken` | `IOSSecuritySuite.amIJailbroken()` | `RootBeer.isRooted` |
| `isDeveloperMode` | `IOSSecuritySuite.amIRunInEmulator()` | `Settings.Global.DEVELOPMENT_SETTINGS_ENABLED` is on |

On iOS, `isDeveloperMode` does not read the iOS Developer Mode setting. It returns `true` when the app runs in the simulator.

## Failure handling

- If the native result is `null`, both APIs return `true`.
- If the native call fails, both APIs throw `PlatformException`. The app decides whether a failed check blocks the user.

## Migration from flutter_jailbreak_detection_plus

| flutter_jailbreak_detection_plus | flutter_jailbreak_guard |
|---|---|
| `FlutterJailbreakDetectionPlus.jailbroken` | `FlutterJailbreakGuard.isJailbroken` |
| `FlutterJailbreakDetectionPlus.developerMode` | `FlutterJailbreakGuard.isDeveloperMode` |

The detection engines and the fallback values are the same.

## Comparison with other packages

Data comes from the source code of the latest version on pub.dev, checked on 2026-10-15.

| Package | Version | iOS engine | Android engine | iOS SPM | Min iOS / Android API | Fallback when the result is missing | Android thread | Package tests |
|---|---|---|---|---|---|---|---|---|
| **flutter_jailbreak_guard** | 0.2.0 | IOSSecuritySuite 2.2+ | RootBeer 0.1.2 | Yes | 13.0 / 24 | `true` | Background task queue | Dart, Kotlin |
| [flutter_jailbreak_detection_plus](https://pub.dev/packages/flutter_jailbreak_detection_plus) | 1.10.7 (2025-10) | IOSSecuritySuite, no version pin | RootBeer 0.1.1 | No | 10.0 / 17 | `true` | Platform thread | None |
| [flutter_jailbreak_detection](https://pub.dev/packages/flutter_jailbreak_detection) | 1.10.0 (2023-01) | IOSSecuritySuite, no version pin | RootBeer 0.1.0 | No | 10.0 / 17 | `true` | Platform thread | None |
| [root_jailbreak_guard](https://pub.dev/packages/root_jailbreak_guard) | 1.1.1 (2026-09) | IOSSecuritySuite 2.2+ | RootBeer 0.1.2 | Yes | 13.0 / 21 | `true` | Platform thread | None |
| [jailbreak_root_detection](https://pub.dev/packages/jailbreak_root_detection) | 1.2.3 (2026-08) | IOSSecuritySuite 1.9.x | RootBeer 0.1.1 and custom checks | Yes | 11.0 / 21 | `false` | Coroutine (`Dispatchers.Default`) | None |
| [safe_device](https://pub.dev/packages/safe_device) | 1.4.1 (2026-07) | DTTJailbreakDetection 0.4.0 and custom checks | RootBeer 0.1.1 and custom checks | Yes | 12.0 / 21 | `false` | Not checked | Dart |
| [freerasp](https://pub.dev/packages/freerasp) | 8.2.4 (2026-10) | Talsec SDK | Talsec SDK | Yes | 13.0 / 23 | Not applicable (callback API) | Not applicable | None |

### What this package changes

- It keeps the behavior of flutter_jailbreak_detection_plus. The two APIs call the same engine methods and return `true` when the result is missing.
- It adds Swift Package Manager support. flutter_jailbreak_detection_plus and flutter_jailbreak_detection support only CocoaPods.
- It runs the Android checks on a background task queue. `RootBeer.isRooted` reads files and runs `su`. The packages with the same API run it on the platform thread.
- It pins IOSSecuritySuite to 2.2 or later. flutter_jailbreak_detection_plus does not pin a version. jailbreak_root_detection stays on 1.9.x.
- It returns `true` when the result is missing. jailbreak_root_detection and safe_device return `false`, so a failed check lets the user continue.
- It has Dart unit tests, a Kotlin unit test, and integration tests.

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

## Threading

- iOS runs the checks on the main thread. `IOSSecuritySuite.amIJailbroken()` calls `UIApplication.shared.canOpenURL`.
- Android runs the checks on a background task queue. `RootBeer.isRooted` reads files and runs `su`.

## iOS URL schemes

IOSSecuritySuite checks jailbreak app URL schemes with `canOpenURL`. If the app does not list these schemes in `LSApplicationQueriesSchemes`, iOS returns `false` for them. The other checks still run.

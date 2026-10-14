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

`isJailbroken` throws `PlatformException` when the native call fails. The plugin does not choose a fallback value. The app decides whether a failed check blocks the user.

## Threading

- iOS runs the check on the main thread. `IOSSecuritySuite.amIJailbroken()` calls `UIApplication.shared.canOpenURL`.
- Android runs the check on a background task queue. `RootBeer.isRooted` reads files and runs `su`.

## iOS URL schemes

IOSSecuritySuite checks jailbreak app URL schemes with `canOpenURL`. If the app does not list these schemes in `LSApplicationQueriesSchemes`, iOS returns `false` for them. The other checks still run.

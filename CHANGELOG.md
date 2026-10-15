## 0.2.1

* Accept IOSSecuritySuite 1.9.10 or later and earlier than 3.0. Apps can pin the BSD-licensed 1.9.x.
* Rewrite the README: quick start, comparison matrix, migration guide, and iOS engine license.

## 0.2.0

* Add `FlutterJailbreakGuard.isDeveloperMode`. It matches `developerMode` of flutter_jailbreak_detection_plus.
* Return `true` when the native result is `null`. 0.1.0 threw `PlatformException`.
* Add a migration guide and a comparison with other packages to the README.

## 0.1.0

* Add `FlutterJailbreakGuard.isJailbroken`.
* Support Swift Package Manager and CocoaPods on iOS.

import Flutter
import IOSSecuritySuite

public class FlutterJailbreakGuardPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "flutter_jailbreak_guard", binaryMessenger: registrar.messenger())
    registrar.addMethodCallDelegate(FlutterJailbreakGuardPlugin(), channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "isJailbroken":
      result(IOSSecuritySuite.amIJailbroken())
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

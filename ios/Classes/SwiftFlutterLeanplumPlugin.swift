import Flutter
import UIKit
import Leanplum

public class SwiftFlutterLeanplumPlugin: NSObject, FlutterPlugin {
    

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "run.milk.leanplum", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterLeanplumPlugin()
    registrar.addApplicationDelegate(instance)
    registrar.addMethodCallDelegate(instance, channel: channel)
    Leanplum.setVerboseLoggingInDevelopmentMode(true)
  }
  
    
  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "start":
        
        Leanplum.start()
        let userNotifCenter = UNUserNotificationCenter.current()

        userNotifCenter.requestAuthorization(options: [.badge,.alert,.sound]){ (granted,error) in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
        result(nil);
        break;
      case "clearUserContent":
        Leanplum.clearUserContent()
        break;
      case "setUserId":
        if (proceedArguments(call: call, result: result, keys: [ "userId"])) {
            if let arguments = call.arguments, let arg = arguments as? [String: Any] {
                if let value: String = arg["userId"] as? String {
                    Leanplum.setUserId(value)
                    result(nil);
                }
            }
        }
        break;
      case "setAppIdForProductionMode":
        if (proceedArguments(call: call, result: result, keys: [ "appId", "accessKey"])) {
            if let arguments = call.arguments, let arg = arguments as? [String: Any] {
                if let appId: String = arg["appId"] as? String {
                    if let accessKey: String = arg["accessKey"] as? String {
                        Leanplum.setAppId(appId,productionKey: accessKey)
                        result(nil);
                    }
                }
            }
        }
        break;
      case "setAppIdForDevelopmentMode":
        if (proceedArguments(call: call, result: result, keys: [ "appId", "accessKey"])) {
            if let arguments = call.arguments, let arg = arguments as? [String: Any] {
                if let appId: String = arg["appId"] as? String {
                    if let accessKey: String = arg["accessKey"] as? String {
                        Leanplum.setAppId(appId,developmentKey: accessKey)
                        result(nil);
                    }
                }
            }
        }
        break;

      default:
        result(FlutterMethodNotImplemented);

    }
  }


  func proceedArguments(call: FlutterMethodCall, result: @escaping FlutterResult, keys: [String]) -> Bool {
      if let arguments = call.arguments,
          let arg = arguments as? [String: Any] {
          for key in keys {
              if arg[key] == nil {
                  result(FlutterError(code: "ARGUMENT_ERRROR", message: "Key \(key) is empty", details: nil))
                  return false
              }
          }
      } else if (call.arguments == nil) {
          result(FlutterError(code: "ARGUMENT_ERRROR", message: "Arguements is empty", details: nil))
          return false
      }
      return true
  }
    
    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    public func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert, .badge, .sound])
    }
}

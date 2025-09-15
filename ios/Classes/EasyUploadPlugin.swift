import Flutter
import UIKit
import UserNotifications

public class EasyUploadPlugin: NSObject, FlutterPlugin, UNUserNotificationCenterDelegate {

    public func userNotificationCenter(_ center: UNUserNotificationCenter,
                                       willPresent notification: UNNotification,
                                       withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        if #available(iOS 14.0, *) {
            completionHandler([.banner, .sound])
        } else {
            completionHandler([.alert, .sound])
        }
    }

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "easy_upload", binaryMessenger: registrar.messenger())
    let instance = EasyUploadPlugin()
    UNUserNotificationCenter.current().delegate = instance
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "uploadFiles":
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Permission error: \(error)")
            }
        }
     if let args = call.arguments as? [String: Any],
         let filePath = args["file_path"] as? String,
         let uploadUrl = args["upload_url"] as? String {
        guard let uploadURL = URL(string: uploadUrl) else {
          result(FlutterError(code: "INVALID_URL", message: "Upload URL is invalid", details: nil))
          return
        }

        FileUploadService.shared.upload(
          fileUrl: filePath,
          uploadUrl: uploadURL,
          progressCallback: { progress in
            print("Progress: \(progress)")
            // Можно отправлять прогресс в Flutter через EventChannel, если потребуется
          },
          completion: { success in
            if success {
              result("Upload successful")
            } else {
              result(FlutterError(code: "UPLOAD_FAILED", message: "File upload failed", details: nil))
            }
          }
        )

      } else {
        result(FlutterError(code: "INVALID_ARGUMENTS", message: "Missing filePath or uploadUrl", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}

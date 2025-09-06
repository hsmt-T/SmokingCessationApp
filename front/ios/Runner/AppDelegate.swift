import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    private var initialLink: String?

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let deeplinkChannel = FlutterMethodChannel(name: "nosmoke/deeplink", binaryMessenger: controller.binaryMessenger)

        deeplinkChannel.setMethodCallHandler { [weak self] (call, result) in
            if call.method == "getInitialLink" {
                result(self?.initialLink)
                self?.initialLink = nil
            } else {
                result(FlutterMethodNotImplemented)
            }
        }

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if url.scheme == "nosmoke" && url.host == "callback" {
            initialLink = url.absoluteString
            return true
        }
        return false
    }
}

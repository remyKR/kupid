import UIKit
import Flutter
// import GoogleSignIn  // 👈 꼭 필요!

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ✅ Google 로그인 완료 후 앱으로 돌아오는 URL 처리
  // override func application(_ app: UIApplication,
  //                          open url: URL,
  //                          options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
  //   return GIDSignIn.sharedInstance.handle(url)
  // }
}

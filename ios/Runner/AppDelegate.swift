import Flutter
import UIKit
import GoogleSignIn

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    print("=== iOS AppDelegate Starting ===")
    
    // Configure Google Sign-In with your iOS Client ID
    let clientId = "418880569981-rhqdotqk52ii81uhp7df0pulslh94ivf.apps.googleusercontent.com"
    
    print("Configuring Google Sign-In with Client ID: \(clientId)")
    
    let config = GIDConfiguration(clientID: clientId)
    GIDSignIn.sharedInstance.configuration = config
    print("Google Sign-In configured successfully")
    
    GeneratedPluginRegistrant.register(with: self)
    print("Flutter plugins registered")
    
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    print("=== URL RECEIVED: \(url) ===")
    
    if GIDSignIn.sharedInstance.handle(url) {
      print("Google Sign-In handled URL successfully")
      return true
    }
    
    print("URL not handled by Google Sign-In, passing to super")
    return super.application(app, open: url, options: options)
  }
}

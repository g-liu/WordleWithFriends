//
//  AppDelegate.swift
//  WordleWithFriends
//
//  Created by Geoffrey Liu on 1/14/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    window = UIWindow(frame: UIScreen.main.bounds)
    let homeViewController = UINavigationController(rootViewController: GameSetupViewController())

    window!.rootViewController = homeViewController
    window!.makeKeyAndVisible()
    
    // Read default settings
    if let defaultSettings = readPropertyList("GameSettingsDefaults") {
      UserDefaults.standard.register(defaults: defaultSettings)
    }
    
    return true
  }
  
  private func readPropertyList(_ name: String) -> [String: Any]? {
    guard let plistPath = Bundle.main.path(forResource: name, ofType: "plist"),
          let plistData = FileManager.default.contents(atPath: plistPath) else {
            return nil
          }
    
    return try? PropertyListSerialization.propertyList(from: plistData, format: nil) as? [String: Any]
  }
}


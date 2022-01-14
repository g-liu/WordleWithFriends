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
    let homeViewController = UINavigationController(rootViewController: ViewController())

    window!.rootViewController = homeViewController
    window!.makeKeyAndVisible()
    return true
  }
}


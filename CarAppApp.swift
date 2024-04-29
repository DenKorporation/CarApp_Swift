//
//  CarAppApp.swift
//  CarApp
//
//  Created by VMWare on 16.04.24.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct CarAppApp: App {
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var authManager = AuthManager()

  var body: some Scene {
    WindowGroup {
        Wrapper()
            .environmentObject(authManager)
    }
  }
}

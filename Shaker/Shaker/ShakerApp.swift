//
//  ShakerApp.swift
//  Shaker
//
//  Created by Anna Maksimova on 2022-11-21.
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
struct ShakerApp: App {
    
    @StateObject private var firebaseManager: FirebaseManager = .init()
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    init() {
//        FirebaseApp.configure()
//    }
    
    var body: some Scene {
        WindowGroup {
            MainPageView()
                .environmentObject(firebaseManager)
        }
    }
}




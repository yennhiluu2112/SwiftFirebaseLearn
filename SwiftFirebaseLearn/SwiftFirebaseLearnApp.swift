//
//  SwiftFirebaseLearnApp.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 8/12/24.
//

import SwiftUI
import Firebase

@main
struct SwiftFirebaseLearnApp: App {
//    init(){
//        FirebaseApp.configure()
//    }
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
//            RootView()
//            PerformanceView()
            AnalyticsView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }
}


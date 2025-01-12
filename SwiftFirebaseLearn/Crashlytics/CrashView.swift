//
//  CrashView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 12/1/25.
//

import SwiftUI
import FirebaseCrashlytics

final class CrashManager {
    static let shared = CrashManager()
    private init() {}
    
    func setUserId(uid: String) {
        Crashlytics.crashlytics().setUserID(uid)
    }
    
    func setValue(value: String, key: String) {
        Crashlytics.crashlytics()
            .setCustomValue(value, forKey: key)
    }
    
    func setIsPremiumValue(isPremium: Bool) {
        Crashlytics.crashlytics()
            .setCustomValue(isPremium.description.lowercased(), forKey: "user_is_premium")
    }
    
    func addLogger(message: String) {
        Crashlytics.crashlytics().log(message)
    }
    
    func sendNonFatal(error: Error) {
        Crashlytics.crashlytics().record(error: error)
    }
}

struct CrashView: View {
    var body: some View {
        ZStack {
            Color(.gray).opacity(0.3).ignoresSafeArea()
            
            VStack {
                Button("Click me 1") {
                    CrashManager.shared.addLogger(message: "Button 1 click")
                    let myString: String? = nil
                    guard let myString else {
                        CrashManager.shared.sendNonFatal(error: URLError(.dataNotAllowed))
                        return
                    }
                    let string2 = myString
                }
                
                Button("Click me 2") {
                    CrashManager.shared.addLogger(message: "Button 2 click")
                    fatalError("This was a fatal crash")
                }
                
                Button("Click me 3") {
                    CrashManager.shared.addLogger(message: "Button 3 click")
                    let array: [String] = []
                    let item = array[0]
                }
            }
        }
        .onAppear {
            CrashManager.shared.setUserId(uid: "ABC123")
            CrashManager.shared.setValue(value: "TRUE", key: "isPremium")
            CrashManager.shared.setIsPremiumValue(isPremium: true)
            CrashManager.shared.addLogger(message: "Crash view appeared on user screen")
        }
    }
}

#Preview {
    CrashView()
}

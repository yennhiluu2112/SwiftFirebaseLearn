//
//  AnalyticsView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 12/1/25.
//

import SwiftUI
import FirebaseAnalytics

final class AnalyticsManager {
    static let shared = AnalyticsManager()
    private init() {}
    
    func logEvent(name: String, parameters: [String: Any]? = nil) {
        Analytics.logEvent(name, parameters: parameters)
    }
    
    func setUserId(uid: String){
        Analytics.setUserID(uid)
    }
    
    func setUserProperty(value: String?, forName: String) {
        Analytics.setUserProperty(value, forName: forName)
    }
}

struct AnalyticsView: View {
    var body: some View {
        VStack {
            Button("Click me") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_ButtonClick")
            }
            
            Button("Click me 2") {
                AnalyticsManager.shared.logEvent(name: "AnalyticsView_ButtonClick2", parameters: ["screen_title": "Hello world"])
            }
        }
        .analyticsScreen(name: "AnalyticsView")
        .onAppear {
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Appeared")
            AnalyticsManager.shared.setUserId(uid: "ABC!@3")
            AnalyticsManager.shared.setUserProperty(value: true.description, forName: "user_is_premium")
        }
        .onDisappear{
            AnalyticsManager.shared.logEvent(name: "AnalyticsView_Disappeared")
        }
    }
}

#Preview {
    AnalyticsView()
}

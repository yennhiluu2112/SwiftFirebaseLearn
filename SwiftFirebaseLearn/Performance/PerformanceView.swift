//
//  PerformanceView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 12/1/25.
//

import SwiftUI
import FirebasePerformance

final class PerformaceManager {
    static let shared = PerformaceManager()
    private init() {}
    
    private var traces: [String: Trace?] = [:]
    
    func startTrace(name: String) {
        let trace = Performance.startTrace(name: name)
        traces[name] = trace
    }
    
    func setValue(name: String, value: String, forAttribute: String) {
        guard let trace = traces[name] else { return }
        trace?.setValue(value, forAttribute: forAttribute)
    }
    
    func stopTrace(name: String){
        guard let trace = traces[name] else { return }
        trace?.stop()
        traces.removeValue(forKey: name)
    }
}

struct PerformanceView: View {
    @State private var title: String = "Some title"

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .onAppear {
                configure()
                downloadProductsAndUploadToFirebase()
                PerformaceManager.shared.startTrace(name: "performance_screen_time")
            }
            .onDisappear {
                PerformaceManager.shared.stopTrace(name: "performance_screen_time")
            }
    }
    
    private func configure() {
        PerformaceManager.shared.startTrace(name: "performance_view_loading")

        Task {
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformaceManager.shared.setValue(name: "performance_view_loading",
                                              value: "Started downloading",
                                              forAttribute: "func_state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformaceManager.shared.setValue(name: "performance_view_loading",
                                              value: "Continue downloading",
                                              forAttribute:"func_state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformaceManager.shared.setValue(name: "performance_view_loading",
                                              value: "Finished downloading",
                                              forAttribute:"func_state")
            try? await Task.sleep(nanoseconds: 2_000_000_000)
            PerformaceManager.shared.stopTrace(name: "performance_view_loading")
        }
    }
    
    private func downloadProductsAndUploadToFirebase() {
        let urlString = "https://dummyjson.com/products"
        guard let url = URL(string: urlString),
              let metric = HTTPMetric(url: url, httpMethod: .get)
        else { return }
        
        Task {
            do {
                let (data, response) = try await URLSession.shared.data(from: url)
                if let response = response as? HTTPURLResponse {
                    metric.responseCode = response.statusCode
                }
                metric.stop()
            } catch {
                print(error)
                metric.stop()
            }
        }
    }
}

#Preview {
    PerformanceView()
}

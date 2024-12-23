//
//  ProfileView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 22/12/24.
//

import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    
    @Published private(set) var user: DBUser? = nil
    
    func loadCurrentUser() async throws {
        let authDataResult = try AuthenticationManager.shared.getAuthenticatedUser()
        self.user = try await UserManager.shared.getUser(uid: authDataResult.uid)
    }
    
    func togglePremiumStatus() {
        guard let user else { return }
        let currentValue = user.isPremium ?? false
        Task {
            UserManager.shared.updateUserPremiumStatus(uid: user.uid,
                                                           isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(uid: user.uid)

        }
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    var body: some View {
        List {
            if let user = viewModel.user {
                Text("User id: \(user.uid)")
                
                if let isAnonymous = user.isAnonymous {
                    Text("Is anonymous: \(isAnonymous.description.capitalized)")
                }
                
                Button(action: {
                    viewModel.togglePremiumStatus()
                }, label: {
                    Text("User is premium: \((user.isPremium ?? false).description.capitalized)")
                })
            }
        }
        .task {
            try? await viewModel.loadCurrentUser()
        }
        .navigationTitle("Profile")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink {
                    SettingsView(showSignInView: $showSignInView)
                } label: {
                    Image(systemName: "gear")
                        .font(.headline)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(showSignInView: .constant(false))
    }
}

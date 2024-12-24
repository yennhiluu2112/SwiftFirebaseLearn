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
            try await UserManager.shared.updateUserPremiumStatus(uid: user.uid,
                                                           isPremium: !currentValue)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func addUserPreference(text: String) {
        guard let user else { return }
        Task {
            try await UserManager.shared.addUserPreference(uid: user.uid,
                                                 preference: text)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func removeUserPreference(text: String) {
        guard let user else { return }
        Task {
            try await  UserManager.shared.removeUserPreference(uid: user.uid,
                                                 preference: text)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func addFavoriteMovie() {
        guard let user else { return }
        let movie = Movie(id: "1", title: "Avatar", isPopular: true)
        Task {
            try await UserManager.shared.addFavoriteMovie(uid: user.uid, movie: movie)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
    
    func removeFavoriteMovie() {
        guard let user else { return }
        Task {
            try await UserManager.shared.removeFavoriteMovie(uid: user.uid)
            self.user = try await UserManager.shared.getUser(uid: user.uid)
        }
    }
}

struct ProfileView: View {
    
    @StateObject private var viewModel = ProfileViewModel()
    @Binding var showSignInView: Bool
    
    let preferenceOptions: [String] = ["Sports", "Movies", "Books"]
    
    private func isPreferenceSelected(text: String) -> Bool {
        return (viewModel.user?.preferences ?? [] ).contains(text)
    }
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
                
                VStack {
                    HStack {
                        ForEach(preferenceOptions, id: \.self) { string in
                            Button(action: {
                                if isPreferenceSelected(text: string) {
                                    viewModel.removeUserPreference(text: string)
                                } else {
                                    viewModel.addUserPreference(text: string)
                                }
                            }, label: {
                                Text(string)
                            })
                            .font(.headline)
                            .buttonStyle(.borderedProminent)
                            .tint(isPreferenceSelected(text: string) ? .green : .red)
                        }
                    }
                    
                    Text("User preferences: \((user.preferences ?? []).joined(separator: ", "))")
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                
                Button(action: {
                    if user.favoriteMovie == nil {
                        viewModel.addFavoriteMovie()
                    } else {
                        viewModel.removeFavoriteMovie()
                    }
                }, label: {
                    Text("Favorite Movie: \(user.favoriteMovie?.title ?? "")")
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
    RootView()
}

//
//  SettingsView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 9/12/24.
//

import SwiftUI

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var authProviders: [AuthProviderOption] = []
    @Published var authUser: AuthDataResultModel? = nil
    
    func loadAuthUser() {
        self.authUser = try? AuthenticationManager.shared.getAuthenticatedUser()
    }

    func loadAuthProviders() {
        if let providers = try? AuthenticationManager.shared.getProviders() {
            authProviders = providers
        }
    }
    
    func logOut() throws {
        try AuthenticationManager.shared.signOut()
    }
    
    func resetPassword() async throws {
        let authUser = try AuthenticationManager.shared.getAuthenticatedUser()
        
        guard let email = authUser.email else {
            throw URLError(.fileDoesNotExist)
        }
        try await AuthenticationManager.shared.resetPassword(email: email)
    }
    
    func updateEmail() async throws {
        let email = "abc@gmail.com"
        try await AuthenticationManager.shared.updateEmail(email: email)
    }
    
    func updatePassword() async throws {
        let password = "hello123"
        try await AuthenticationManager.shared.updatePassword(password: password)
    }
    
    func linkGoogleAccount() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        self.authUser = try await AuthenticationManager.shared.linkGoogle(tokens: tokens)
    }
    
    func linkAppleAccount() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        self.authUser = try await AuthenticationManager.shared.linkApple(tokens: tokens)
    }
    
    func linkEmailAccount() async throws {
        let email = "abc@gmail.com"
        let password = "123456"
        self.authUser = try await AuthenticationManager.shared.linkEmail(email: email, password: password)
    }
}

struct SettingsView: View {
    
    @StateObject private var viewModel = SettingsViewModel()
    @Binding var showSignInView: Bool
    
    var body: some View {
        List {
            Button {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Log out")
            }
            
            if viewModel.authProviders.contains(.email) {
                emailSection
            }
            
            if viewModel.authUser?.isAnonymous ?? false {
                anonymousSection
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
            viewModel.loadAuthUser()
        }
        .navigationTitle("Settings")
    }
}

extension SettingsView {
    private var emailSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.resetPassword()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Reset password")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updatePassword()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update password")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.updateEmail()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Update email")
            }
        } header: {
            Text("Email functions")
        }
    }
    
    private var anonymousSection: some View {
        Section {
            Button {
                Task {
                    do {
                        try await viewModel.linkGoogleAccount()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Link Google Account")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.linkAppleAccount()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Link Apple Account")
            }
            
            Button {
                Task {
                    do {
                        try await viewModel.linkEmailAccount()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Link Email Account")
            }
        } header: {
            Text("Create account")
        }
    }
}

#Preview {
    NavigationStack {
        SettingsView(showSignInView: .constant(false))
    }
}

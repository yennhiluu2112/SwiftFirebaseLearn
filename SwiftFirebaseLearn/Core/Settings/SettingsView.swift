//
//  SettingsView.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 9/12/24.
//

import SwiftUI

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
            
            Button(role: .destructive) {
                Task {
                    do {
                        try await viewModel.deleteAccount()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete account")
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

//
//  SignInEmailViewModel.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 22/12/24.
//

import Foundation

@MainActor
final class SignInEmailViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    
    func signIn() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        let authDataResult = try await AuthenticationManager.shared.createUser(email: email, password: password)
        let user = DBUser(auth: authDataResult)
        try UserManager.shared.createNewUser(user: user)
    }
    
    func signUp() async throws {
        guard !email.isEmpty, !password.isEmpty else {
            print("No email or password found")
            return
        }
        
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
    }
    
}

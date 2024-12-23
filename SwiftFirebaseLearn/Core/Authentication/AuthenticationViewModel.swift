//
//  AuthenticationViewModel.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 22/12/24.
//

import Foundation

@MainActor
final class AuthenticationViewModel: ObservableObject {
    
//    @Published var didSignInWithApple: Bool = false
    
    func signInGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let authDataResult = try await AuthenticationManager.shared.signInWithGoogle(tokens: tokens)
        try createNewUser(authDataResult: authDataResult)
    }
    
    func signInApple() async throws {
        let helper = SignInAppleHelper()
        let tokens = try await helper.startSignInWithAppleFlow()
        let authDataResult = try await AuthenticationManager.shared.signInWithApple(tokens: tokens)
        try createNewUser(authDataResult: authDataResult)
    }
    
    func signInAnonymous() async throws {
        let authDataResult = try await AuthenticationManager.shared.signInAnonymous()
        try createNewUser(authDataResult: authDataResult)
    }
    
    func createNewUser(authDataResult: AuthDataResultModel) throws {
        let user = DBUser(auth: authDataResult)
        try UserManager.shared.createNewUser(user: user)
    }
}

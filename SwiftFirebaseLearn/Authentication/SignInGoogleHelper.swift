//
//  SignInGoogleHelper.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 18/12/24.
//

import Foundation
import GoogleSignIn
import GoogleSignInSwift

struct GoogleSignInResultModel {
    let idToken: String
    let accessToken: String
    let name: String?
    let email: String?
}

final class SignInGoogleHelper {
    func signIn() async throws -> GoogleSignInResultModel {
        guard let topVC = await Utilities.shared.topViewController() else {
            throw URLError(.cannotFindHost)
        }
        let gidSignInResult = try await GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
        
        let user = gidSignInResult.user
        guard let idToken = user.idToken?.tokenString else {
            throw URLError(.badServerResponse)
        }
        
        let accessToken = user.accessToken.tokenString
        
        let name = user.profile?.name
        let email = user.profile?.email
        
        let tokens = GoogleSignInResultModel(idToken: idToken,
                                             accessToken: accessToken,
                                             name: name,
                                             email: email)
        return tokens
    }
}

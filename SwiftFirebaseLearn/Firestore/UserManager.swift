//
//  UserManager.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 22/12/24.
//

import Foundation
import FirebaseFirestore

struct DBUser {
    let uid: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    func createNewUser(auth: AuthDataResultModel) async throws {
        var userData: [String: Any] = [
            "user_id": auth.uid,
            "is_anonymous": auth.isAnonymous,
            "date_created": Timestamp()
        ]
        
        if let email = auth.email {
            userData["email"] = email
        }
        
        if let photoURL = auth.photoURL{
            userData["photo_url"] = photoURL
        }
        try await Firestore.firestore().collection("users").document(auth.uid).setData(userData, merge: false)
    }
    
    func getUser(uid: String) async throws -> DBUser {
        let snapshot = try await Firestore.firestore().collection("users").document(uid).getDocument()
        guard let data = snapshot.data(), let uid = data["user_id"] as? String else {
            throw URLError(.badServerResponse)
        }
        
        let isAnonymous = data["is_anonymous"] as? Bool
        let email = data["email"] as? String
        let photoUrl = data["photo_url"] as? String
        let dateCreated = data["date_created"] as? Date

        return DBUser(uid: uid, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
    }
}

//
//  UserManager.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 22/12/24.
//

import Foundation
import FirebaseFirestore

struct DBUser: Codable {
    let uid: String
    let isAnonymous: Bool?
    let email: String?
    let photoUrl: String?
    let dateCreated: Date?
    let isPremium: Bool?
    
    init(auth: AuthDataResultModel) {
        self.uid = auth.uid
        self.isAnonymous = auth.isAnonymous
        self.email = auth.email
        self.photoUrl = auth.photoURL
        self.dateCreated = Date()
        self.isPremium = false
    }
    
    init(uid: String,
         isAnonymous: Bool? = nil,
         email: String? = nil, 
         photoUrl: String? = nil,
         dateCreated: Date? = nil,
         isPremium: Bool? = nil
    ) {
        self.uid = uid
        self.isAnonymous = isAnonymous
        self.email = email
        self.photoUrl = photoUrl
        self.dateCreated = dateCreated
        self.isPremium = isPremium
    }
    
//    mutating func togglePremiumStatus() {
//        let currentValue = isPremium ?? false
//        isPremium = !currentValue
//    }
    
    enum CodingKeys: String, CodingKey {
        case uid = "uid"
        case isAnonymous = "is_anonymous"
        case email = "email"
        case photoUrl = "photo_url"
        case dateCreated = "date_created"
        case isPremium = "is_premium"
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.uid, forKey: .uid)
        try container.encode(self.email, forKey: .email)
        try container.encode(self.isAnonymous, forKey: .isAnonymous)
        try container.encode(self.photoUrl, forKey: .photoUrl)
        try container.encode(self.dateCreated, forKey: .dateCreated)
        try container.encode(self.isPremium, forKey: .isPremium)
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.uid = try container.decode(String.self, forKey: .uid)
        self.isAnonymous = try container.decodeIfPresent(Bool.self, forKey: .isAnonymous)
        self.email = try container.decodeIfPresent(String.self, forKey: .email)
        self.photoUrl = try container.decodeIfPresent(String.self, forKey: .photoUrl)
        self.dateCreated = try container.decodeIfPresent(Date.self, forKey: .dateCreated)
        self.isPremium = try container.decodeIfPresent(Bool.self, forKey: .isPremium)
    }
}

final class UserManager {
    static let shared = UserManager()
    private init() {}
    
    private let userCollection = Firestore.firestore().collection("users")
    private func userDocument(uid: String) -> DocumentReference {
        return userCollection.document(uid)
    }
    
//    private let encoder: Firestore.Encoder = {
//        let encoder = Firestore.Encoder()
//        encoder.keyEncodingStrategy = .convertToSnakeCase
//        return encoder
//    }()
//    
//    private let decoder: Firestore.Decoder = {
//        let decoder = Firestore.Decoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        return decoder
//    }()
    
    func createNewUser(user: DBUser) throws {
        try userDocument(uid: user.uid).setData(from: user, merge: false)
    }
    
    func getUser(uid: String) async throws -> DBUser {
        return try await userDocument(uid: uid).getDocument(as: DBUser.self)
    }
    
    func updateUserPremiumStatus(uid: String, isPremium: Bool) {
        let data: [String: Any] = [
            DBUser.CodingKeys.isPremium.rawValue : isPremium
        ]
        userDocument(uid: uid).updateData(data)
    }

//    func createNewUser(auth: AuthDataResultModel) async throws {
//        var userData: [String: Any] = [
//            "user_id": auth.uid,
//            "is_anonymous": auth.isAnonymous,
//            "date_created": Timestamp()
//        ]
//        
//        if let email = auth.email {
//            userData["email"] = email
//        }
//        
//        if let photoURL = auth.photoURL{
//            userData["photo_url"] = photoURL
//        }
//        try await userDocument(uid: auth.uid).setData(userData, merge: false)
//    }
    
//    func getUser(uid: String) async throws -> DBUser {
//        let snapshot = try await userDocument(uid: uid).getDocument()
//        guard let data = snapshot.data(), let uid = data["user_id"] as? String else {
//            throw URLError(.badServerResponse)
//        }
//        
//        let isAnonymous = data["is_anonymous"] as? Bool
//        let email = data["email"] as? String
//        let photoUrl = data["photo_url"] as? String
//        let dateCreated = data["date_created"] as? Date
//
//        return DBUser(uid: uid, isAnonymous: isAnonymous, email: email, photoUrl: photoUrl, dateCreated: dateCreated)
//    }
}

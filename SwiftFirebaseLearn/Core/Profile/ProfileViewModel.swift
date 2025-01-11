//
//  ProfileViewModel.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 24/12/24.
//

import Foundation
import PhotosUI
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
    
    func saveImage(item: PhotosPickerItem)  {
        guard let user else { return }
        Task {
            guard let data = try await item.loadTransferable(type: Data.self) else { return }
            let (path, name) = try await StorageManager.shared.saveImage(data: data, uid: user.uid)
            let url = try await StorageManager.shared.getUrlForImage(path: path)
            try await UserManager.shared.updateUserProfileImage(uid: user.uid, path: path, url: url.absoluteString)
        }
    }
    
    func deleteImage()  {
        guard let user, let path = user.profileImagePath else { return }
        Task {
            try await StorageManager.shared.deleteImage(path: path)
            try await UserManager.shared.updateUserProfileImage(uid: user.uid)
        }
    }
}

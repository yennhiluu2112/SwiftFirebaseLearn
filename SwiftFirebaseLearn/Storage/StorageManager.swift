//
//  StorageManager.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 10/1/25.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    private init() {}
    
    private let storage = Storage.storage().reference()
    
    private var imagesReference: StorageReference {
        storage.child("images")
    }
    
    private func userReference(uid: String) -> StorageReference {
        storage.child("users").child(uid)
    }
    
    func getPathForImage(path: String) -> StorageReference {
        Storage.storage().reference(withPath: path)
    }
    func getUrlForImage(path: String) async throws -> URL {
        try await getPathForImage(path: path).downloadURL()
    }
    
    func getData(uid: String, path: String) async throws -> Data {
        try await storage.child(path).data(maxSize: 3 * 1024 * 1024)
    }
    
    func getImage(uid: String, path: String) async throws -> UIImage {
        let data = try await getData(uid: uid, path: path)
        guard let image = UIImage(data: data) else {
            throw URLError(.badURL)
        }
        return image
    }
    
    func saveImage(data: Data, uid: String) async throws -> (path: String, name: String) {
        
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let path = "\(UUID().uuidString).jpeg"
        let returnedMetaData = try await userReference(uid: uid).child(path).putDataAsync(data, metadata: meta)
        
        guard let returnedPath = returnedMetaData.path, let returnedName = returnedMetaData.name else {
            throw URLError(.badServerResponse)
        }
        
        return (returnedPath, returnedName)
    }
    
    func saveImage(image: UIImage, uid: String) async throws -> (path: String, name: String) {
        //image.pngData()
        
        guard let data = image.jpegData(compressionQuality: 1) else {
            throw URLError(.backgroundSessionWasDisconnected)
        }
        
        return try await saveImage(data: data, uid: uid)
    }
    
    func deleteImage(path: String) async throws {
        try await getPathForImage(path: path).delete()
    }
    
}

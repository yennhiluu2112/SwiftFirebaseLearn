//
//  ProductsManager.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 24/12/24.
//

import Foundation
import FirebaseFirestore

final class ProductsManager {
    static let shared = ProductsManager()
    private init() {}
    
    private let productCollection = Firestore.firestore().collection("products")
    
    private func productDocument(id: String) -> DocumentReference {
        return productCollection.document(id)
    }
    
    func uploadProduct(product: Product) throws {
        try productDocument(id: String(product.id)).setData(from: product, merge: false)
    }
    
    func getAllProducts() async throws -> [Product] {
        try await productCollection.getAllDocuments(as: Product.self)
    }
    
    func getProduct(id: String) async throws -> Product {
        try await productDocument(id: id).getDocument(as: Product.self)
    }
}

extension Query {
    func getAllDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        return try snapshot.documents.map { document in
            return try document.data(as: T.self)
        }
    }
}

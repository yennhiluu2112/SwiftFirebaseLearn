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
    
    private func getAllProductsSortedByPrice(descending: Bool) async throws -> [Product]  {
        try await productCollection
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getAllDocuments(as: Product.self)
    }
    
    private func getAllProductsForCategory(category: String) async throws -> [Product]  {
        try await productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .getAllDocuments(as: Product.self)
    }
    
    private func getAllProductsByPrice(descending: Bool, category: String) async throws -> [Product] {
        try await productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
            .getAllDocuments(as: Product.self)
    }
    
    func getAllProductsByPrice(priceDescending descending: Bool?, forCategory category: String?) async throws -> [Product] {
        if let descending, let category {
            return try await getAllProductsByPrice(descending: descending, category: category)
        } else if let descending {
            return try await getAllProductsSortedByPrice(descending: descending)
        } else if let category {
            return try await getAllProductsForCategory(category: category)
        }
        return try await getAllProducts()
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

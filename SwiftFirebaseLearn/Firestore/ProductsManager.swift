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
        try productDocument(id: String(product.id))
            .setData(from: product, merge: false)
    }
    
    func getProduct(id: String) async throws -> Product {
        try await productDocument(id: id)
            .getDocument(as: Product.self)
    }
    
    func getAllProductsQuery() -> Query {
        productCollection
    }
    
    private func getAllProductsSortedByPriceQuery(descending: Bool) -> Query  {
        productCollection.order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    private func getAllProductsForCategoryQuery(category: String) -> Query {
        productCollection.whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
    }
    
    private func getAllProductsByPriceAndCategoryQuery(descending: Bool, category: String) -> Query {
        productCollection
            .whereField(Product.CodingKeys.category.rawValue, isEqualTo: category)
            .order(by: Product.CodingKeys.price.rawValue, descending: descending)
    }
    
    func getProducts(priceDescending descending: Bool?, 
                     forCategory category: String?,
                     count: Int,
                     lastDocument: DocumentSnapshot?) async throws -> (array: [Product], lastDoc: DocumentSnapshot?) {
        var query: Query = getAllProductsQuery()
        if let descending, let category {
            query = getAllProductsByPriceAndCategoryQuery(descending: descending, category: category)
        } else if let descending {
            query = getAllProductsSortedByPriceQuery(descending: descending)
        } else if let category {
            query = getAllProductsForCategoryQuery(category: category)
        }
        
        return try await query
            .limit(to: count)
            .startOptionally(afterDocument: lastDocument)
            .getDocumentsWithSnapshot(as: Product.self)
    }
    
    func getAllProductsCount() async throws -> Int {
        try await productCollection.aggregateCount()
    }
    
//
//    func getProductsByRating(count: Int, lastRating: Double?) async throws -> [Product] {
//        return try await productCollection
//            .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//            .limit(to: count)
//            .start(after: [lastRating ?? 99999])
//            .getAllDocuments(as: Product.self)
//    }
//    
//    func getProductsByRating(count: Int, lastDocument: DocumentSnapshot?) async throws -> (array: [Product], lastDoc: DocumentSnapshot?) {
//        if let lastDocument {
//            return try await productCollection
//                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .start(afterDocument: lastDocument)
//                .getDocumentsWithSnapshot(as: Product.self)
//        } else {
//            return try await productCollection
//                .order(by: Product.CodingKeys.rating.rawValue, descending: true)
//                .limit(to: count)
//                .getDocumentsWithSnapshot(as: Product.self)
//        }
//    }
}

extension Query {
//    func getAllDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
//        let snapshot = try await self.getDocuments()
//        
//        return try snapshot.documents.map { document in
//            return try document.data(as: T.self)
//        }
//    }
    
    func getAllDocuments<T>(as type: T.Type) async throws -> [T] where T: Decodable {
        try await getDocumentsWithSnapshot(as: type).array
    }
    
    func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> (array: [T], lastDoc: DocumentSnapshot?) where T: Decodable {
        let snapshot = try await self.getDocuments()
        
        let array = try snapshot.documents.map { document in
            return try document.data(as: T.self)
        }
        
        return (array, snapshot.documents.last)
    }
    
    func startOptionally(afterDocument lastDocument: DocumentSnapshot?) -> Query {
        guard let lastDocument else { return self }
        return self.start(afterDocument: lastDocument)
    }
    
    func aggregateCount() async throws -> Int {
        let snapshot = try await self.count.getAggregation(source: .server)
        return Int(truncating: snapshot.count)
    }
}

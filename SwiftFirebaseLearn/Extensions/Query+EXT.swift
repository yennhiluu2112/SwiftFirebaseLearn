//
//  Query+EXT.swift
//  SwiftFirebaseLearn
//
//  Created by Luu Yen Nhi on 8/1/25.
//

import Foundation
import Combine
import FirebaseFirestore

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
    
    func addSnapshotListener<T>(as type: T.Type) -> (AnyPublisher<[T], Error>, ListenerRegistration) where T: Decodable  {
        let publisher = PassthroughSubject<[T], Error>()
        
        let listener = self.addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }
            
            let data: [T] = documents.compactMap { try? $0.data(as: T.self)}
            publisher.send(data)
        }
        
        return (publisher.eraseToAnyPublisher(), listener)
    }
}

//
//  Firestore+Query.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 15.05.2026.
//

import Foundation
import FirebaseFirestore

extension Query {
    func getDocuments<T: Decodable>(as type: T.Type) async throws -> [T] {
        let snapshot = try await getDocuments()
        
        return snapshot.documents.compactMap({ try? $0.data(as: T.self) })
    }
}

//
//  LikesCache.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 08.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class SavedPostCache: UserActivityCache {
    private let refreshInterval: TimeInterval = 60 * 60 * 24
    static let shared = SavedPostCache()
    
    private init() {
        super.init(refreshInterval: refreshInterval, cacheIdentifier: "saved-posts")
    }
}

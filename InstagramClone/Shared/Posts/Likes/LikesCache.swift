//
//  LikesCache.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 08.05.2026.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class LikesCache: UserActivityCache {
    private let refreshInterval: TimeInterval = 60 * 60 * 24
    
    init() {
        super.init(refreshInterval: refreshInterval, cacheIdentifier: "user-likes")
    }
}


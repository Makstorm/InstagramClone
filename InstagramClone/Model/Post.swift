//
//  Post.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 17.04.2026.
//

import Foundation

struct Post: Identifiable, Hashable, Codable {
    let id: String
    let ownerUid: String
    let caption: String
    var likes: Int
    let imageUrl: String
    let timestamb: Date
    var user: User?
    
    var didLike: Bool? = false
}

extension Post {
    static let MOCK_IMAGE_URL = "https://firebasestorage.googleapis.com:443/v0/b/instagramcloneapp-9509a.firebasestorage.app/o/profile_images%2F9624881E-E382-423A-A6CA-D47C22401ED1?alt=media&token=09356138-e001-429b-91ef-105d1b3c1418"
    
}

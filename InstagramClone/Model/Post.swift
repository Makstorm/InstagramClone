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
    
    var didLike: Bool = false
    var didSave: Bool = false
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.ownerUid = try container.decode(String.self, forKey: .ownerUid)
        self.caption = try container.decode(String.self, forKey: .caption)
        self.likes = try container.decode(Int.self, forKey: .likes)
        self.imageUrl = try container.decode(String.self, forKey: .imageUrl)
        self.timestamb = try container.decode(Date.self, forKey: .timestamb)
        
        self.user = try container.decodeIfPresent(User.self, forKey: .user)
        self.didLike = try container.decodeIfPresent(Bool.self, forKey: .didLike) ?? false
        self.didSave = try container.decodeIfPresent(Bool.self, forKey: .didSave) ?? false
    }
    
    init(id: String, ownerUid: String, caption: String, likes: Int, imageUrl: String, timestamb: Date, user: User? = nil, didLike: Bool = false, didSave: Bool = false) {
        self.id = id
        self.ownerUid = ownerUid
        self.caption = caption
        self.likes = likes
        self.imageUrl = imageUrl
        self.timestamb = timestamb
        self.user = user
        self.didLike = didLike
        self.didSave = didSave
    }
}

extension Post {
    static let MOCK_IMAGE_URL = "https://firebasestorage.googleapis.com:443/v0/b/instagramcloneapp-9509a.firebasestorage.app/o/profile_images%2F9624881E-E382-423A-A6CA-D47C22401ED1?alt=media&token=09356138-e001-429b-91ef-105d1b3c1418"
    
}

//
//  MockData.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 05.05.2026.
//

import Foundation

class MockData {
    static var posts: [Post] = [
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
        .init(
            id: NSUUID().uuidString,
            ownerUid: users[0].id,
            caption: "this is some test caption for now",
            likes: 0,
            imageUrl: "batman-2",
            timestamp: Date(),
        ),
    ]
    
    static var users: [User] = [
        .init(id: NSUUID().uuidString, username: "batman", profileImageUrl: nil, fullname: "Bruce Wayne", bio: "Gotham's Dark Knight", email: "batman@gmail.com", isPrivate: true),
        .init(id: NSUUID().uuidString, username: "venom", profileImageUrl: nil, fullname: "Edie Brock", bio: "Venom", email: "venom@gmail.com", isPrivate: false),
        .init(id: NSUUID().uuidString, username: "batman", profileImageUrl: nil, fullname: "Bruce Wayne", bio: "Gotham's Dark Knight", email: "batman@gmail.com", isPrivate: true),
        .init(id: NSUUID().uuidString, username: "spiderman", profileImageUrl: nil, fullname: "Peter Parker", bio: "Test bio", email: "spiderman@gmail.com", isPrivate: false),
    ]
    
    static var comments: [Comment] = [
        .init(id: UUID().uuidString, postOwnerUid: posts[0].ownerUid, commnetText: "Test comment for me", postId: posts[0].id, timestamp: Date(), commentOwnerUid: users[0].id),
        .init(id: UUID().uuidString, postOwnerUid: posts[0].ownerUid, commnetText: "Test comment for me", postId: posts[0].id, timestamp: Date(), commentOwnerUid: users[0].id),
        .init(id: UUID().uuidString, postOwnerUid: posts[0].ownerUid, commnetText: "Test comment for me", postId: posts[0].id, timestamp: Date(), commentOwnerUid: users[0].id),
        .init(id: UUID().uuidString, postOwnerUid: posts[0].ownerUid, commnetText: "Test comment for me", postId: posts[0].id, timestamp: Date(), commentOwnerUid: users[0].id),
        .init(id: UUID().uuidString, postOwnerUid: posts[0].ownerUid, commnetText: "Test comment for me", postId: posts[0].id, timestamp: Date(), commentOwnerUid: users[0].id),
    ]
    
    static var followRequests: [FollowRequest] = [
        .init(id: UUID().uuidString, toUserId: users[1].id, fromUserId: users[0].id, timestamp: Date(), user: users.first),
    ]
}

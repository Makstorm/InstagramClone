//
//  Constants.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 23.04.2026.
//

import Foundation
import Firebase
import FirebaseFirestore

struct FirebaseConstants {
    static let Root = Firestore.firestore()
    
    static let UserCollection = Root.collection("users")
    
    static let PostsCollection = Root.collection("posts")
    
    static let FollowingCollection = Root.collection("following")
    static let FollowersCollection = Root.collection("followers")
    
    static let NotificationsCollection = Root.collection("notifications")
    
    static func UserNotificationCollection(uid: String) -> CollectionReference {
        return NotificationsCollection.document(uid).collection("user-notifications")
    }
    
    static func UserSavedPostsCollection(uid: String) -> CollectionReference {
        return UserCollection.document(uid).collection("saved-posts")
    }
    
    static func UserFeedCollection(uid: String) -> CollectionReference {
        return UserCollection.document(uid).collection("user-feed")
    }
}

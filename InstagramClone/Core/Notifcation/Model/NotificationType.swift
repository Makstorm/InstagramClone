//
//  NotificationType.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 24.04.2026.
//

import Foundation

enum NotificationType: Int, Codable {
    case like
    case comment
    case follow
    case followRequestAccepted
    
    var notificationMessage: String {
        switch self {
        case .like: return "liked one of your posts."
        case .comment: return "commented one of your posts."
        case .follow: return "started following you."
        case .followRequestAccepted: return " accepted your follow request."
        }
    }
}

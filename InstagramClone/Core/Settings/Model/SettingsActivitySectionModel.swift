//
//  SettingsActivitySectionModel.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import Foundation

enum SettingsActivitySectionModel: Int, CaseIterable {
    case savedPosts
    case likePosts
}

extension SettingsActivitySectionModel: Identifiable, Hashable {
    var id: Int {
        return self.rawValue
    }
}

extension SettingsActivitySectionModel: CustomStringConvertible {
    var description: String {
        switch self {
        case .savedPosts:
            return "Saved posts"
        case .likePosts:
            return "Liked posts"
        }
    }
}

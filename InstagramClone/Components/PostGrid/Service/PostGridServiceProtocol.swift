//
//  PostGridServiceProtocol.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 10.05.2026.
//

import Foundation

protocol PostGridServiceProtocol {
    func fetchPosts() async throws -> [Post]
    func refreshPosts() async throws -> [Post]
}

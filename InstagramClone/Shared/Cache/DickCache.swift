//
//  DickCache.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 08.05.2026.
//

import Foundation

struct DiskCache {
    static let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func save<T: Codable>(_ object: T, to file: String) throws {
        let fileUrl = directory.appending(path: file)
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileUrl)
    }
    
    static func loadData<T: Codable>(_ file: String, as type: T.Type) throws -> T {
        let fileUrl = directory.appending(path: file)
        let data = try Data(contentsOf: fileUrl)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

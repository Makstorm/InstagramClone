//
//  UserActivityCache.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 09.05.2026.
//

import Foundation
import FirebaseAuth 
import FirebaseFirestore

class UserActivityCache {
    private var cache = NSCache<NSString, NSArray>()
    private var lastFetched = [String: Date]()
    
    private let refreshInterval: TimeInterval
    private let cacheIdentifier: String
    
    init(refreshInterval: TimeInterval, cacheIdentifier: String) {
        print("DEBUG: Got here, initializing cache: \(cacheIdentifier)")
        self.refreshInterval = refreshInterval
        self.cacheIdentifier = cacheIdentifier
        
        initializeCache()
    }
    
    func initializeCache() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if let lastFetchedTime = loadLastFetched(for: uid) {
            lastFetched[uid] = lastFetchedTime
        }
        loadCacheData()
        
        print("DEBUG: Got cache:",cache)
    }
    
    func set(_ items: [String]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        cache.setObject(items as NSArray, forKey: uid as NSString)
        saveToDisk(items, for: uid)
    }
    
    func contains(_ item: String) -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let items = cache.object(forKey: uid as NSString) as? [String] else { return false }
        return items.contains(item)
    }
    
    func update(_ item: String, didAdd: Bool) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var items = cache.object(forKey: uid as NSString) as? [String] ?? []
        
        if didAdd {
            items.append(item)
        } else {
            items.removeAll { $0 == item }
        }
        
        set(items)
    }
    
}

private extension UserActivityCache {
    func loadCacheData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        if needsRefresh {
            Task {
                let ref = FirebaseConstants.UserCollection.document(uid).collection(cacheIdentifier)
                let snapshot = try await ref.getDocuments()
                let items = snapshot.documents.map { $0.documentID }
                set(items)
                saveLastFetched(for: uid, date: Date())
            }
        } else {
            loadCacheFromDisk(for: uid)
        }
    }
}

private extension UserActivityCache {
    func saveToDisk(_ items: [String], for uid: String) {
        do {
            let fileName = fileName(uid: uid)
            try DiskCache.save(items, to: fileName)
        } catch {
            print("DEBUG: Failed to save saved posts to Disk with error \(error.localizedDescription)")
        }
    }
    
    func loadCacheFromDisk(for uid: String) {
        do {
            let fileName = fileName(uid: uid)
            let items = try DiskCache.loadData(fileName, as: [String].self)
            set(items)
        } catch {
            print("DEBUG: Failed to load saved posts from Disk with error \(error.localizedDescription)")
        }
    }
    
    func fileName(uid: String) -> String {
        return "\(cacheIdentifier)_\(uid).json"
    }
}

private extension UserActivityCache {
    func saveLastFetched(for uid: String, date: Date) {
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "lastFetched_\(uid)_\(cacheIdentifier)")
        lastFetched[uid] = date
    }
    
    func loadLastFetched(for uid: String) -> Date? {
        let userDefaults = UserDefaults.standard
        return userDefaults.object(forKey: "lastFetched_\(uid)_\(cacheIdentifier)") as? Date
    }
    
    var needsRefresh: Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let lastFetched = lastFetched[uid] else { return true }
        return Date().timeIntervalSince(lastFetched) > refreshInterval
    }
}

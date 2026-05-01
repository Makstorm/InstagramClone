//
//  Ешьуіефьз.swift
//  InstagramClone
//
//  Created by Maxym Horobets on 23.04.2026.
//

import Foundation
import Firebase

extension Timestamp {
    func timestampString() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [ .second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: self.dateValue(), to: Date()) ?? "" 
    }
}

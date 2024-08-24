//
//  Challenge.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import Foundation
import SwiftData

@Model
final class Challenge {
    var name: String
    var date: Date
    var notifications: Bool
    
    init(name: String, date: Date, notifications: Bool) {
        self.name = name
        self.date = date
        self.notifications = notifications
    }
}

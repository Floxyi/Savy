//
//  Saving.swift
//  Savy
//
//  Created by Florian Winkler on 01.09.24.
//

import Foundation
import SwiftData

@Model
final class Saving {
    var id: UUID
    var challengeId: UUID
    var amount: Int
    var date: Date
    var done: Bool
    
    init(challengeId: UUID, amount: Int, date: Date, done: Bool) {
        self.id = UUID()
        self.challengeId = challengeId
        self.amount = amount
        self.date = date
        self.done = done
    }
    
    func markAsDone() {
        done = true
    }
    
    func markAsUnDone() {
        done = false
    }
}

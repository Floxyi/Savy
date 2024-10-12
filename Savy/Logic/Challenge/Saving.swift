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
    private(set) var id: UUID
    private(set) var challengeId: UUID
    private(set) var amount: Int
    private(set) var date: Date
    private(set) var done: Bool
    
    init(challengeId: UUID, amount: Int, date: Date) {
        self.id = UUID()
        self.challengeId = challengeId
        self.amount = amount
        self.date = date
        self.done = false
    }
    
    func toggleDone() {
        done.toggle()
        done ? StatsTracker.shared.addMoneySavedStatsEntry(savingId: id, amount: amount, date: date) : StatsTracker.shared.deleteStatsEntry(savingId: id)
    }
    
    func setAmount(amount: Int) {
        self.amount = amount
    }
}

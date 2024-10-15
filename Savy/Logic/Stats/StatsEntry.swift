//
//  StatsEntry 2.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//


import Foundation
import SwiftData

@Model
class StatsEntry {
    var type: StatsType
    var date: Date
    var savingStats: SavingStats?
    var challengeStats: ChallengeStats?
    
<<<<<<< Updated upstream
=======
    // Initializes a new stats entry with type, date, and optional stats
>>>>>>> Stashed changes
    init(type: StatsType, date: Date, savingStats: SavingStats? = nil, challengeStats: ChallengeStats? = nil) {
        self.type = type
        self.date = Calendar.current.startOfDay(for: date)
        self.savingStats = savingStats
        self.challengeStats = challengeStats
    }
}

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

    init(type: StatsType, date: Date, savingStats: SavingStats? = nil, challengeStats: ChallengeStats? = nil) {
        self.type = type
        self.date = Calendar.current.startOfDay(for: date)
        self.savingStats = savingStats
        self.challengeStats = challengeStats
    }
}

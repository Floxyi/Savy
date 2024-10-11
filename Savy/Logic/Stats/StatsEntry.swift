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
    
    init(type: StatsType, date: Date, savingStats: SavingStats? = nil) {
        self.type = type
        self.date = date
        self.savingStats = savingStats
    }
}

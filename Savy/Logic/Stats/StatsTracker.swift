//
//  StatsTracker.swift
//  Savy
//
//  Created by Nadine Schatz on 11.10.24.
//

import Foundation
import SwiftData

@Model
class StatsTracker {
    static let shared = StatsTracker()
    
    private(set) var entries: [StatsEntry] = []
    
    init() { }
    
    func addStatsEntry(entry: StatsEntry) {
        entries.append(entry)
    }
}

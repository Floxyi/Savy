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
    var id: UUID
    var name: String
    var icon: String
    var startDate: Date
    var endDate: Date
    var targetAmount: Int
    @Relationship(deleteRule: .cascade) var savings: [Saving] = []
    
    init(name: String, icon: String, startDate: Date, endDate: Date, targetAmount: Int) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.startDate = startDate
        self.endDate = endDate
        self.targetAmount = targetAmount
    }
    
    func currentSavedAmount() -> Int {
        return savings.filter { $0.done }.reduce(0) { $0 + $1.amount }
    }
    
    func progressPercentage() -> Double {
        let totalSaved = currentSavedAmount()
        return min((Double(totalSaved) / Double(targetAmount)) * 100.0, 100.0)
    }
    
    func remainingAmount() -> Int {
        return max(targetAmount - currentSavedAmount(), 0)
    }
    
    func daysRemaining() -> Int {
        return max(Calendar.current.dateComponents([.day], from: Date(), to: endDate).day ?? 0, 0)
    }
    
    func isCompleted() -> Bool {
        return currentSavedAmount() >= targetAmount || Date() > endDate
    }
}

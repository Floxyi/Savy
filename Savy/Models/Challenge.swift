//
//  Challenge.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import Foundation
import SwiftData

@Model
class Challenge {
    public var id: UUID
    public var name: String
    public var icon: String
    public var startDate: Date
    public var endDate: Date
    public var targetAmount: Int
    public var savings: [Saving] = []
    
    init(name: String, icon: String, startDate: Date, endDate: Date, targetAmount: Int) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.startDate = startDate
        self.endDate = endDate
        self.targetAmount = targetAmount
        
        generateSavings()
    }
    
    private func generateSavings() {
        let calendar = Calendar.current
        var savings: [Saving] = []
        var date = calendar.date(byAdding: .month, value: 1, to: startDate)!
        
        let numberOfMonths = self.numberOfMonths()
        let amountPerMonth = (targetAmount + numberOfMonths - 1) / numberOfMonths
        
        while date <= endDate {
            let saving = Saving(challengeId: id, amount: amountPerMonth, date: date, done: false)
            savings.append(saving)
            
            if let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) {
                date = nextMonth
            } else {
                break
            }
        }
        
        if let lastSaving = savings.last {
            let totalSaved = savings.reduce(0) { $0 + $1.amount }
            lastSaving.amount += targetAmount - totalSaved
        }
        
        self.savings = savings
    }
    
    private func numberOfMonths() -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.month], from: startDate, to: endDate).month ?? 0
    }
    
    func currentSavedAmount() -> Int {
        return savings.filter { $0.done }.reduce(0) { $0 + $1.amount }
    }
    
    func progressPercentage() -> Double {
        return Double(currentSavedAmount()) / Double(targetAmount)
    }
    
    func remainingAmount() -> Int {
        return max(targetAmount - currentSavedAmount(), 0)
    }
    
    func remainingSavings() -> Int {
        return savings.filter { !$0.done }.count
    }
    
    func getNextSaving() -> Saving {
        return savings[0]
    }
    
    func getNextNextSaving() -> Saving {
        return savings[1]
    }
}

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
    
    init(name: String, icon: String, startDate: Date, endDate: Date, targetAmount: Int, strategy: Strategy) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.startDate = startDate
        self.endDate = endDate
        self.targetAmount = targetAmount
        
        generateSavings(strategy: strategy)
    }
    
    private func generateSavings(strategy: Strategy) {
        let calendar = Calendar.current
        var savings: [Saving] = []
        var date = calendar.date(byAdding: strategy == .Monthly ? .month : .weekOfYear, value: 1, to: startDate)!
        
        let numberOfCyles = strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks()
        let amountPerCyles = (targetAmount + numberOfCyles - 1) / numberOfCyles
        
        while date <= endDate {
            let saving = Saving(challengeId: id, amount: amountPerCyles, date: date, done: false)
            savings.append(saving)
            
            if strategy == .Monthly {
                if let nextMonth = calendar.date(byAdding: .month, value: 1, to: date) {
                    date = nextMonth
                } else {
                    break
                }
            } else {
                if let nextWeek = calendar.date(byAdding: .weekOfYear, value: 1, to: date) {
                    date = nextWeek
                } else {
                    break
                }
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
    
    private func numberOfWeeks() -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.weekOfYear], from: startDate, to: endDate).weekOfYear ?? 0
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

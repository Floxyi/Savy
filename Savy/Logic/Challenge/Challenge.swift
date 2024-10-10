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
    
    init(name: String, icon: String, startDate: Date, endDate: Date, targetAmount: Int, strategy: SavingStrategy) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.startDate = startDate
        self.endDate = endDate
        self.targetAmount = targetAmount
        
        generateSavings(strategy: strategy)
    }
    
    private func generateSavings(strategy: SavingStrategy) {
        let calendar = Calendar.current
        var date = calendar.date(byAdding: strategy == .Monthly ? .month : .weekOfYear, value: 1, to: startDate)!
        
        let numberOfCyles = strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks()
        let amountPerCyles = (targetAmount + numberOfCyles - 1) / numberOfCyles
        
        while startOfDay(for: date) <= startOfDay(for: endDate) {
            savings.append(Saving(challengeId: id, amount: amountPerCyles, date: date, done: false))
            let nextDate = nextDate(from: date, strategy: strategy, calendar: calendar)
            date = nextDate!
        }
        
        let lastSaving = savings.last!
        let totalSaved = savings.reduce(0) { $0 + $1.amount }
        lastSaving.amount += targetAmount - totalSaved
    }
    
    private func startOfDay(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    private func nextDate(from date: Date, strategy: SavingStrategy, calendar: Calendar) -> Date? {
        return calendar.date(byAdding: strategy == .Weekly ? .weekOfYear : .month, value: 1, to: date)
    }
    
    private func numberOfMonths() -> Int {
        let calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.year, .month], from: startDate)
        let startYear = startComponents.year ?? 0
        let startMonth = startComponents.month ?? 0
        
        let endComponents = calendar.dateComponents([.year, .month], from: endDate)
        let endYear = endComponents.year ?? 0
        let endMonth = endComponents.month ?? 0
        
        let yearDifference = (endYear - startYear) * 12
        let monthDifference = endMonth - startMonth
        
        return yearDifference + monthDifference
    }
    
    private func numberOfWeeks() -> Int {
        let calendar = Calendar.current
        
        let startComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: startDate)
        let startYearForWeek = startComponents.yearForWeekOfYear ?? 0
        let startWeek = startComponents.weekOfYear ?? 0
        
        let endComponents = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: endDate)
        let endYearForWeek = endComponents.yearForWeekOfYear ?? 0
        let endWeek = endComponents.weekOfYear ?? 0
        
        let yearDifference = (endYearForWeek - startYearForWeek) * 52
        let weekDifference = endWeek - startWeek
        
        return yearDifference + weekDifference
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
        return savings.sorted { $0.date < $1.date }.first { !$0.done } ?? savings.first!
    }
    
    func getNextNextSaving() -> Saving {
        let sortedNotDoneSavings = savings.sorted { $0.date < $1.date }.filter { !$0.done }
        return sortedNotDoneSavings.count > 1 ? sortedNotDoneSavings[1] : savings.first!
    }
}

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
    private(set) var id: UUID
    private(set) var name: String
    private(set) var icon: String
    private(set) var startDate: Date
    private(set) var endDate: Date
    private(set) var targetAmount: Int
    private(set) var savings: [Saving] = []
    
    init(
        name: String,
        icon: String,
        startDate: Date,
        endDate: Date,
        targetAmount: Int,
        strategy: SavingStrategy,
        calculation: SavingCalculation,
        savingAmount: Int? = nil
    ) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.startDate = startDate
        self.endDate = endDate
        self.targetAmount = targetAmount
        
        generateSavings(strategy: strategy, calculation: calculation, savingAmount: savingAmount)
    }
    
    private func generateSavings(strategy: SavingStrategy, calculation: SavingCalculation, savingAmount: Int? = nil) {
        let calendar = Calendar.current
        var date = calendar.date(byAdding: strategy == .Monthly ? .month : .weekOfYear, value: 1, to: startDate)!
        
        let numberOfCycles = strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks()
        let amountPerCycles = calculation == .Date ? targetAmount / numberOfCycles : savingAmount!
        
        while startOfDay(for: date) <= startOfDay(for: endDate) {
            savings.append(Saving(amount: amountPerCycles, date: date))
            let nextDate = nextDate(from: date, strategy: strategy, calendar: calendar)
            date = nextDate!
        }
        
        let lastSaving = savings.last!
        let totalSaved = savings.reduce(0) { $0 + $1.amount }
        let lastSavingAmount = lastSaving.amount + targetAmount - totalSaved
        
        if lastSavingAmount <= 0 {
            savings.removeLast()
        }
        
        if lastSavingAmount < 0 {
            let secondLastSaving = savings.last!
            secondLastSaving.setAmount(amount: secondLastSaving.amount + lastSavingAmount)
        }
        
        if calculation == .Date {
            lastSaving.setAmount(amount: lastSaving.amount + targetAmount - totalSaved)
        }
        
        if calculation == .Amount {
            savings.append(Saving(amount: targetAmount - totalSaved, date: date))
        }
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
    
    func getNextSaving(at n: Int) -> Saving {
        let undoneSavings = savings.sorted { $0.date < $1.date }.filter { !$0.done }
        return undoneSavings.count >= n ? undoneSavings[n - 1] : savings.first!
    }
}

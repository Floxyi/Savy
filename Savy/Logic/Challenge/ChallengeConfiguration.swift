//
//  ChallengeConfiguration.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import Foundation
import SwiftData

@Model
class ChallengeConfiguration {
    private(set) var icon: String
    private(set) var name: String
    private(set) var amount: Int
    private(set) var startDate: Date
    private(set) var endDate: Date
    private(set) var strategy: SavingStrategy
    private(set) var calculation: SavingCalculation
    private(set) var cycleAmount: Int?
    
    init(
        icon: String,
        name: String,
        amount: Int,
        startDate: Date = Date(),
        endDate: Date = Date(),
        strategy: SavingStrategy,
        calculation: SavingCalculation,
        cycleAmount: Int? = nil
    ) {
        self.icon = icon
        self.name = name
        self.amount = amount
        self.startDate = startDate
        self.endDate = endDate
        self.strategy = strategy
        self.calculation = calculation
        self.cycleAmount = cycleAmount
        
        calculation == .Amount ? self.endDate = calculateEndDateByAmount() : nil
    }
    
    func generateSavings(challenge: Challenge) {
        let calendar = Calendar.current
        var date = calendar.date(byAdding: strategy == .Monthly ? .month : .weekOfYear, value: 1, to: startDate)!
        
        let numberOfCycles = strategy == .Monthly ? numberOfMonths() : numberOfWeeks()
        let amountPerCycles = calculation == .Date ? amount / numberOfCycles : cycleAmount!
        
        while startOfDay(for: date) <= startOfDay(for: endDate) {
            challenge.addSaving(saving: Saving(challengeId: challenge.id, amount: amountPerCycles, date: date))
            let nextDate = nextDate(from: date, strategy: strategy, calendar: calendar)
            date = nextDate!
        }
        
        let savedAmount = challenge.savings.reduce(0) { $0 + $1.amount }
        
        if savedAmount > amount {
            let overflow = savedAmount - amount
            let lastSaving = challenge.savings.last!
            if challenge.savings.last!.amount - overflow > 0 {
                lastSaving.setAmount(amount: lastSaving.amount - overflow)
                challenge.updateSaving(saving: lastSaving)
            } else {
                challenge.removeSaving(saving: lastSaving)
                let secondLastSaving = challenge.savings.last!
                secondLastSaving.setAmount(amount: secondLastSaving.amount - overflow)
                challenge.updateSaving(saving: secondLastSaving)
            }
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
    
    func calculateEndDateByAmount() -> Date {
        let date = Date()
        
        if cycleAmount == nil {
            return date
        }
        
        let numberOfCycles = amount / cycleAmount!
        
        return Calendar.current.date(
            byAdding: strategy == .Monthly ? .month : .weekOfYear,
            value: numberOfCycles * cycleAmount! == amount ? numberOfCycles : numberOfCycles + 1,
            to: date
        ) ?? date
    }
    
    func calculateCycleAmount() -> Int? {
        let duration = strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks()
        let numberOfCyles = duration != 0 ? duration : nil
        return numberOfCyles != nil ? (amount + numberOfCyles! - 1) / numberOfCyles! : nil
    }
}

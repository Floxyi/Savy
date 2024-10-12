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
    }
    
    func generateSavings(challenge: Challenge, startDate: Date? = nil) {
        let calendar = Calendar.current
        var date = startDate ?? nextDate(from: self.startDate, strategy: strategy, calendar: calendar)!
        
        let finishedSavings = challenge.savings.filter { $0.done }
        let preSavedAmount = finishedSavings.reduce(0) { $0 + $1.amount }
        let targetAmount = amount - preSavedAmount
        
        if calculation == .Amount {
            if startDate != nil {
                self.endDate = calculateEndDateByAmount(challenge: challenge, startDate: startDate)
            } else {
                self.endDate = calculateEndDateByAmount(challenge: challenge)
            }
        }
        
        let numberOfCycles = strategy == .Monthly ? numberOfMonths(startDate: date, endDate: endDate) : numberOfWeeks(startDate: date, endDate: endDate)
        let amountPerCycle = calculation == .Date ? targetAmount / numberOfCycles : cycleAmount!
        
        while startOfDay(for: date) <= startOfDay(for: endDate) {
            challenge.addSaving(saving: Saving(challengeId: challenge.id, amount: amountPerCycle, date: date))
            date = nextDate(from: date, strategy: strategy, calendar: calendar)!
        }
        
        let savedAmount = challenge.savings.reduce(0) { $0 + $1.amount }
        
        if savedAmount > amount {
            let overflow = savedAmount - amount
            let lastSaving = challenge.savings.last!
            
            if lastSaving.amount - overflow > 0 {
                lastSaving.setAmount(amount: lastSaving.amount - overflow)
                challenge.updateSaving(saving: lastSaving)
            } else if lastSaving.amount - overflow == 0 {
                challenge.removeSaving(saving: lastSaving)
            } else {
                challenge.removeSaving(saving: lastSaving)
                let secondLastSaving = challenge.savings.last!
                secondLastSaving.setAmount(amount: secondLastSaving.amount - overflow)
                challenge.updateSaving(saving: secondLastSaving)
            }
        }
        
        if challenge.savings.last!.amount < 0 {
            let lastSaving = challenge.savings.last!
            lastSaving.setAmount(amount: lastSaving.amount + cycleAmount!)
            challenge.updateSaving(saving: lastSaving)
        }
    }
    
    func regenerateSavings(challenge: Challenge) {
        challenge.savings.filter { !$0.done }.forEach { saving in
            challenge.removeSaving(saving: saving)
        }
        
        let lastDate = challenge.savings.count > 0 ? challenge.savings.last!.date : self.startDate
        let nextDate = nextDate(from: lastDate, strategy: strategy, calendar: Calendar.current)!
        generateSavings(challenge: challenge, startDate: nextDate)
    }
    
    private func startOfDay(for date: Date) -> Date {
        let calendar = Calendar.current
        return calendar.startOfDay(for: date)
    }
    
    private func nextDate(from date: Date, strategy: SavingStrategy, calendar: Calendar) -> Date? {
        return calendar.date(byAdding: strategy == .Weekly ? .weekOfYear : .month, value: 1, to: date)
    }
    
    private func numberOfMonths(startDate: Date, endDate: Date) -> Int {
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
    
    private func numberOfWeeks(startDate: Date, endDate: Date) -> Int {
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
    
    func calculateEndDateByAmount(challenge: Challenge? = nil, startDate: Date? = nil) -> Date {
        var targetAmount = amount
        let date = startDate != nil ? startDate! : self.startDate
        
        if challenge != nil {
            let finishedSavings = challenge!.savings.filter { $0.done }
            let preSavedAmount = finishedSavings.reduce(0) { $0 + $1.amount }
            targetAmount -= preSavedAmount
        }
        
        if cycleAmount == nil {
            return date
        }
        
        let numberOfCycles = targetAmount / cycleAmount!
        
        let endDate = Calendar.current.date(
            byAdding: strategy == .Monthly ? .month : .weekOfYear,
            value: numberOfCycles * cycleAmount! == targetAmount ? numberOfCycles : numberOfCycles + 1,
            to: date
        ) ?? date
        
        return endDate
    }
    
    func calculateCycleAmount() -> Int? {
        let duration: Int

        if strategy == .Monthly {
            duration = numberOfMonths(startDate: startDate, endDate: endDate)
        } else {
            duration = numberOfWeeks(startDate: startDate, endDate: endDate)
        }
        
        let numberOfCyles = duration != 0 ? duration : nil
        return numberOfCyles != nil ? (amount + numberOfCyles! - 1) / numberOfCyles! : nil
    }
}

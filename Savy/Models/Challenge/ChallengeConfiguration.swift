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
    @Attribute(.unique) var id: UUID
    var icon: String
    var name: String
    var amount: Int
    var startDate: Date
    var endDate: Date
    var strategy: SavingStrategy
    var calculation: SavingCalculation
    var cycleAmount: Int?

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
        id = UUID()
        self.icon = icon
        self.name = name
        self.amount = amount
        self.startDate = startDate
        self.endDate = endDate
        self.strategy = strategy
        self.calculation = calculation
        self.cycleAmount = cycleAmount
    }

    func generateSavings(challenge: Challenge) {
        generateSavings(challenge: challenge, amount: amount, startDate: startDate)
    }

    private func generateSavings(challenge: Challenge, amount: Int, startDate: Date, presaved: Int = 0) {
        if calculation == .Date {
            generateSavingsByDate(challenge: challenge, amount: amount, startDate: startDate, presaved: presaved)
        } else if calculation == .Amount {
            generateSavingsByAmount(challenge: challenge, amount: amount, startDate: startDate, presaved: presaved)
        }
    }

    func regenerateSavings(challenge: Challenge) {
        challenge.savings.filter { !$0.done }.forEach { saving in challenge.removeSaving(saving: saving) }
        let lastDate = challenge.savings.count > 0 ? challenge.savings.last!.date : startDate
        let nextDate = challenge.savings.count > 0 ? nextDate(from: lastDate, strategy: strategy, calendar: Calendar.current)! : lastDate
        let finishedSavings = challenge.savings.filter(\.done)
        let preSavedAmount = finishedSavings.reduce(0) { $0 + $1.amount }
        generateSavings(challenge: challenge, amount: amount - preSavedAmount, startDate: nextDate, presaved: preSavedAmount)
    }

    func generateSavingsByDate(challenge: Challenge, amount: Int, startDate: Date, presaved: Int) {
        let numberOfCycles = numberOfCycles(startDate: startDate)
        let amountPerSaving = amount / numberOfCycles
        let isComplete = numberOfCycles * amountPerSaving == amount

        var currentDate = startDate
        for _ in 0 ..< numberOfCycles {
            let saving = Saving(challenge: challenge, amount: amountPerSaving, date: currentDate)
            challenge.addSaving(saving: saving)
            currentDate = nextDate(from: currentDate, strategy: strategy, calendar: Calendar.current)!
        }

        if !isComplete {
            let lastSaving = challenge.savings.last!
            let savedAmount = challenge.savings.reduce(0) { $0 + $1.amount } - presaved
            let lastSavingAmount = lastSaving.amount - (savedAmount - amount)
            if lastSavingAmount > 0 {
                lastSaving.amount = lastSavingAmount
                challenge.updateSaving(saving: lastSaving)
            } else {
                challenge.removeSaving(saving: lastSaving)
            }
        }
    }

    func generateSavingsByAmount(challenge: Challenge, amount: Int, startDate: Date, presaved: Int) {
        let savingsAmount = amount / cycleAmount!
        let isComplete = savingsAmount * cycleAmount! == amount
        let savingsCount = isComplete ? savingsAmount : savingsAmount + 1

        var currentDate = startDate
        for _ in 0 ..< savingsCount {
            let saving = Saving(challenge: challenge, amount: cycleAmount!, date: currentDate)
            challenge.addSaving(saving: saving)
            currentDate = nextDate(from: currentDate, strategy: strategy, calendar: Calendar.current)!
        }

        endDate = challenge.savings.last!.date

        if !isComplete {
            let lastSaving = challenge.savings.last!
            let savedAmount = challenge.savings.reduce(0) { $0 + $1.amount } - presaved
            let lastSavingAmount = lastSaving.amount - (savedAmount - amount)
            if lastSavingAmount > 0 {
                lastSaving.amount = lastSavingAmount
                challenge.updateSaving(saving: lastSaving)
            } else {
                challenge.removeSaving(saving: lastSaving)
            }
        }
    }

    private func nextDate(from date: Date, strategy: SavingStrategy, calendar: Calendar) -> Date? {
        calendar.date(byAdding: strategy.calendarComponent, value: strategy.increment, to: date)
    }

    func calculateEndDateByAmount(challenge: Challenge? = nil, startDate: Date) -> Date {
        var targetAmount = amount

        if challenge != nil {
            let finishedSavings = challenge!.savings.filter(\.done)
            let preSavedAmount = finishedSavings.reduce(0) { $0 + $1.amount }
            targetAmount -= preSavedAmount
        }

        if cycleAmount == nil {
            return startDate
        }

        let numberOfCycles = targetAmount / cycleAmount! - 1
        let endDate = Calendar.current.date(byAdding: strategy.calendarComponent, value: strategy.increment * numberOfCycles, to: startDate) ?? startDate
        return endDate
    }

    func calculateCycleAmount(amount: Int, startDate: Date) -> Int {
        let numberOfCycles = max(1, numberOfCycles(startDate: startDate))
        let amountPerSaving = amount / numberOfCycles
        return amountPerSaving
    }

    private func numberOfCycles(startDate: Date) -> Int {
        var cycles = 1
        if strategy == .Daily { cycles = numberOfDays(startDate: startDate, endDate: endDate) + 1 }
        if strategy == .Weekly { cycles = numberOfWeeks(startDate: startDate, endDate: endDate) + 1 }
        if strategy == .Monthly { cycles = numberOfMonths(startDate: startDate, endDate: endDate) + 1 }
        if strategy == .Quaterly { cycles = (numberOfMonths(startDate: startDate, endDate: endDate) + 1) / 3 }
        if strategy == .Biannually { cycles = (numberOfMonths(startDate: startDate, endDate: endDate) + 1) / 6 }
        if strategy == .Annualy { cycles = (numberOfMonths(startDate: startDate, endDate: endDate) + 1) / 12 }
        return cycles
    }

    private func numberOfDays(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDayStart = calendar.startOfDay(for: startDate)
        let startOfDayEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: startOfDayStart, to: startOfDayEnd)
        let days = components.day ?? 0
        return days
    }

    private func numberOfWeeks(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDayStart = calendar.startOfDay(for: startDate)
        let startOfDayEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: startOfDayStart, to: startOfDayEnd)
        let days = components.day ?? 0
        let fullWeeks = days / 7
        return fullWeeks
    }

    private func numberOfMonths(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDayStart = calendar.startOfDay(for: startDate)
        let startOfDayEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.month], from: startOfDayStart, to: startOfDayEnd)
        let months = components.month ?? 0
        return months
    }
}

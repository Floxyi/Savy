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

    /// Initializes a new `ChallengeConfiguration` with the provided parameters.
    ///
    /// - Parameters:
    ///   - icon: The icon representing the challenge.
    ///   - name: The name of the challenge.
    ///   - amount: The total amount for the challenge.
    ///   - startDate: The starting date of the challenge (default is the current date).
    ///   - endDate: The end date of the challenge (default is the current date).
    ///   - strategy: The saving strategy used to determine how savings are tracked.
    ///   - calculation: The method used to calculate savings over the course of the challenge.
    ///   - cycleAmount: Optional number of items per saving cycle (default is `nil`).
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

    /// Generates the savings for the challenge based on the current configuration.
    ///
    /// - Parameter challenge: The `Challenge` to generate savings for.
    func generateSavings(challenge: Challenge) {
        generateSavings(challenge: challenge, amount: amount, startDate: startDate)
    }

    /// Generates the savings for the challenge with the specified parameters.
    ///
    /// - Parameters:
    ///   - challenge: The `Challenge` to generate savings for.
    ///   - amount: The total amount of savings.
    ///   - startDate: The start date for the savings.
    ///   - presaved: The amount that has already been saved (default is 0).
    private func generateSavings(challenge: Challenge, amount: Int, startDate: Date, presaved: Int = 0) {
        if calculation == .Date {
            generateSavingsByDate(challenge: challenge, amount: amount, startDate: startDate, presaved: presaved)
        } else if calculation == .Amount {
            generateSavingsByAmount(challenge: challenge, amount: amount, startDate: startDate, presaved: presaved)
        }
    }

    /// Regenerates the savings for the challenge, removing incomplete ones and adding new ones.
    ///
    /// - Parameter challenge: The `Challenge` to regenerate savings for.
    func regenerateSavings(challenge: Challenge) {
        challenge.savings.filter { !$0.done }.forEach { saving in challenge.removeSaving(saving: saving) }
        let lastDate = challenge.savings.count > 0 ? challenge.savings.last!.date : startDate
        let nextDate = challenge.savings.count > 0 ? nextDate(from: lastDate, strategy: strategy, calendar: Calendar.current)! : lastDate
        let finishedSavings = challenge.savings.filter(\.done)
        let preSavedAmount = finishedSavings.reduce(0) { $0 + $1.amount }
        generateSavings(challenge: challenge, amount: amount - preSavedAmount, startDate: nextDate, presaved: preSavedAmount)
    }

    /// Generates savings for the challenge based on the date calculation method.
    ///
    /// - Parameters:
    ///   - challenge: The `Challenge` to generate savings for.
    ///   - amount: The total amount of savings.
    ///   - startDate: The start date for the savings.
    ///   - presaved: The amount already saved (default is 0).
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

    /// Generates savings for the challenge based on the amount calculation method.
    ///
    /// - Parameters:
    ///   - challenge: The `Challenge` to generate savings for.
    ///   - amount: The total amount of savings.
    ///   - startDate: The start date for the savings.
    ///   - presaved: The amount already saved (default is 0).
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

    /// Calculates the next date based on the strategy.
    ///
    /// - Parameters:
    ///   - date: The current date to calculate the next date from.
    ///   - strategy: The saving strategy used for the calculation.
    ///   - calendar: The `Calendar` to perform the date calculations with.
    /// - Returns: The next calculated date or `nil` if not possible.
    private func nextDate(from date: Date, strategy: SavingStrategy, calendar: Calendar) -> Date? {
        calendar.date(byAdding: strategy.calendarComponent, value: strategy.increment, to: date)
    }

    /// Calculates the end date based on the amount and start date.
    ///
    /// - Parameters:
    ///   - challenge: The challenge to calculate the end date for (optional).
    ///   - startDate: The start date of the challenge.
    /// - Returns: The calculated end date for the challenge.
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

    /// Calculates the cycle amount based on the challenge amount and start date.
    ///
    /// - Parameters:
    ///   - amount: The total amount for the challenge.
    ///   - startDate: The start date of the challenge.
    /// - Returns: The calculated cycle amount for each saving.
    func calculateCycleAmount(amount: Int, startDate: Date) -> Int {
        let numberOfCycles = max(1, numberOfCycles(startDate: startDate))
        let amountPerSaving = amount / numberOfCycles
        return amountPerSaving
    }

    /// Calculates the number of cycles based on the strategy and start/end dates.
    ///
    /// - Parameter startDate: The start date of the challenge.
    /// - Returns: The number of cycles for the challenge based on the strategy.
    private func numberOfCycles(startDate: Date) -> Int {
        var cycles = 1
        if strategy == .Daily { cycles = numberOfDays(startDate: startDate, endDate: endDate) + 1 }
        if strategy == .Weekly { cycles = numberOfWeeks(startDate: startDate, endDate: endDate) + 1 }
        if strategy == .Monthly { cycles = numberOfMonths(startDate: startDate, endDate: endDate) + 1 }
        if strategy == .Quaterly { cycles = (numberOfMonths(startDate: startDate, endDate: endDate) + 1) / 3 }
        if strategy == .Biannually { cycles = (numberOfMonths(startDate: startDate, endDate: endDate) + 1) / 6 }
        if strategy == .Annually { cycles = (numberOfMonths(startDate: startDate, endDate: endDate) + 1) / 12 }
        return cycles
    }

    /// Calculates the number of days between the start and end date.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the challenge.
    ///   - endDate: The end date of the challenge.
    /// - Returns: The number of days between the two dates.
    private func numberOfDays(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDayStart = calendar.startOfDay(for: startDate)
        let startOfDayEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: startOfDayStart, to: startOfDayEnd)
        let days = components.day ?? 0
        return days
    }

    /// Calculates the number of weeks between the start and end date.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the challenge.
    ///   - endDate: The end date of the challenge.
    /// - Returns: The number of full weeks between the two dates.
    private func numberOfWeeks(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDayStart = calendar.startOfDay(for: startDate)
        let startOfDayEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: startOfDayStart, to: startOfDayEnd)
        let days = components.day ?? 0
        let fullWeeks = days / 7
        return fullWeeks
    }

    /// Calculates the number of months between the start and end date.
    ///
    /// - Parameters:
    ///   - startDate: The start date of the challenge.
    ///   - endDate: The end date of the challenge.
    /// - Returns: The number of months between the two dates.
    private func numberOfMonths(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let startOfDayStart = calendar.startOfDay(for: startDate)
        let startOfDayEnd = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.month], from: startOfDayStart, to: startOfDayEnd)
        let months = components.month ?? 0
        return months
    }
}

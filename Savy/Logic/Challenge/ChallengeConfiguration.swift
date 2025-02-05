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

    func generateSavings(challenge: Challenge, amount: Int, startDate: Date, presaved: Int = 0) {
        if calculation == .Date {
            generateSavingsByDate(challenge: challenge, amount: amount, startDate: startDate, presaved: presaved)
        } else if calculation == .Amount {
            generateSavingsByAmount(challenge: challenge, amount: amount, startDate: startDate, presaved: presaved)
        }
    }

    func generateSavingsByDate(challenge: Challenge, amount: Int, startDate: Date, presaved: Int) {
        let numberOfCycles = strategy == .Weekly ? numberOfWeeks(startDate: startDate, endDate: endDate) : numberOfMonths(startDate: startDate, endDate: endDate)
        var amountPerSaving = amount / numberOfCycles
        let isComplete = numberOfCycles * amountPerSaving == amount

        if !isComplete {
            amountPerSaving += 1
        }

        var currentDate = startDate
        for _ in 0 ..< numberOfCycles {
            let saving = Saving(challengeId: challenge.id, amount: amountPerSaving, date: currentDate)
            challenge.addSaving(saving: saving)
            currentDate = nextDate(from: currentDate, strategy: strategy, calendar: Calendar.current)!
        }

        if !isComplete {
            let lastSaving = challenge.savings.last!
            let savedAmount = challenge.savings.reduce(0) {
                $0 + $1.amount
            } - presaved
            let lastSavingAmount = lastSaving.amount - (savedAmount - amount)
            if lastSavingAmount > 0 {
                lastSaving.setAmount(amount: lastSavingAmount)
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
            let saving = Saving(challengeId: challenge.id, amount: cycleAmount!, date: currentDate)
            challenge.addSaving(saving: saving)
            currentDate = nextDate(from: currentDate, strategy: strategy, calendar: Calendar.current)!
        }

        endDate = challenge.savings.last!.date

        if !isComplete {
            let lastSaving = challenge.savings.last!
            let savedAmount = challenge.savings.reduce(0) {
                $0 + $1.amount
            } - presaved
            let lastSavingAmount = lastSaving.amount - (savedAmount - amount)
            if lastSavingAmount > 0 {
                lastSaving.setAmount(amount: lastSavingAmount)
                challenge.updateSaving(saving: lastSaving)
            } else {
                challenge.removeSaving(saving: lastSaving)
            }
        }
    }

    func regenerateSavings(challenge: Challenge) {
        challenge.savings.filter {
            !$0.done
        }
        .forEach { saving in
            challenge.removeSaving(saving: saving)
        }

        let lastDate = challenge.savings.count > 0 ? challenge.savings.last!.date : startDate
        let nextDate = nextDate(from: lastDate, strategy: strategy, calendar: Calendar.current)!

        let finishedSavings = challenge.savings.filter(\.done)
        let preSavedAmount = finishedSavings.reduce(0) {
            $0 + $1.amount
        }
        generateSavings(challenge: challenge, amount: amount - preSavedAmount, startDate: nextDate, presaved: preSavedAmount)
    }

    private func nextDate(from date: Date, strategy: SavingStrategy, calendar: Calendar) -> Date? {
        calendar.date(byAdding: strategy == .Weekly ? .weekOfYear : .month, value: 1, to: date)
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

    func calculateEndDateByAmount(challenge: Challenge? = nil, startDate: Date) -> Date {
        var targetAmount = amount

        if challenge != nil {
            let finishedSavings = challenge!.savings.filter(\.done)
            let preSavedAmount = finishedSavings.reduce(0) {
                $0 + $1.amount
            }
            targetAmount -= preSavedAmount
        }

        if cycleAmount == nil {
            return startDate
        }

        let numberOfCycles = targetAmount / cycleAmount!

        let endDate = Calendar.current.date(
            byAdding: strategy == .Monthly ? .month : .weekOfYear,
            value: numberOfCycles * cycleAmount! == targetAmount ? numberOfCycles : numberOfCycles + 1,
            to: startDate
        ) ?? startDate

        return endDate
    }

    func calculateCycleAmount(amount: Int, startDate: Date) -> Int {
        if amount <= 0 {
            return amount
        }

        let numberOfCycles = strategy == .Weekly ? numberOfWeeks(startDate: startDate, endDate: endDate) : numberOfMonths(startDate: startDate, endDate: endDate)
        var amountPerSaving = amount / numberOfCycles
        let isComplete = numberOfCycles * amountPerSaving == amount

        if !isComplete {
            amountPerSaving += 1
        }
        return amountPerSaving
    }
}

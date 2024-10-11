//
//  ChallengeConfiguration.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import Foundation

class ChallengeConfiguration {
    public var name: String?
    public var amount: Int?
    public var icon: String?
    public var strategy: SavingStrategy
    public var calculation: SavingCalculation
    public var cycleAmount: Int?
    public var endDate: Date
    
    init(
        name: String? = nil,
        amount: Int? = nil,
        icon: String? = nil,
        strategy: SavingStrategy,
        calculation: SavingCalculation,
        cycleAmount: Int? = nil,
        endDate: Date = Date()
    ) {
        self.name = name
        self.amount = amount
        self.icon = icon
        self.strategy = strategy
        self.calculation = calculation
        self.cycleAmount = cycleAmount
        self.endDate = endDate
    }
    
    private func calculateChallengeEndDate() -> Date {
        let date = Date()

        guard let amount = amount, let cycleAmount = cycleAmount, cycleAmount > 0 else {
            return date
        }
        
        let numberOfCycles = amount / cycleAmount
        
        return Calendar.current.date(
            byAdding: strategy == .Monthly ? .month : .weekOfYear,
            value: numberOfCycles,
            to: date
        ) ?? date
    }
    
    func calculateEndDateByAmount() -> Date {
        let date = Date()

        guard let amount = amount, let cycleAmount = cycleAmount, cycleAmount > 0 else {
            return date
        }
        
        let numberOfCycles = amount / cycleAmount
        
        return Calendar.current.date(
            byAdding: strategy == .Monthly ? .month : .weekOfYear,
            value: numberOfCycles * cycleAmount == amount ? numberOfCycles : numberOfCycles + 1,
            to: date
        ) ?? date
    }
    
    func calculateCycleAmount() -> Int? {
        let duration = strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks()
        let numberOfCyles = duration == 0 ? nil : duration
        
        guard let amount = amount, let numberOfCyles = numberOfCyles else {
            return amount
        }
        
        let amountPerCyles = (amount + numberOfCyles - 1) / numberOfCyles
        return amountPerCyles
    }
    
    private func numberOfMonths() -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.month], from: Date(), to: endDate).month ?? 0
    }
    
    private func numberOfWeeks() -> Int {
        let calendar = Calendar.current
        return calendar.dateComponents([.weekOfYear], from: Date(), to: endDate).weekOfYear ?? 0
    }
    
    func createChallenge() -> Challenge {
        return Challenge(
            name: name!,
            icon: icon!,
            startDate: Date(),
            endDate: calculation == .Date ? endDate : calculateChallengeEndDate(),
            targetAmount: amount!,
            strategy: strategy,
            calculation: calculation,
            savingAmount: calculation == .Amount ? cycleAmount! : nil
        )
    }
    
    func isValid() -> Bool {
        return icon != nil && name != "" && amount != nil && (calculation == .Amount ? cycleAmount != nil : true)
    }
}

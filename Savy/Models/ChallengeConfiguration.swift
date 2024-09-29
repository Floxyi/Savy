//
//  ChallengeConfiguration.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import Foundation
import SwiftUICore

class ChallengeConfiguration {
    public var name: String?
    public var amount: Int?
    public var icon: String?
    public var strategy: Strategy
    public var calculation: Calculation
    public var cycleAmount: Int?
    public var endDate: Date
    
    init(
        name: String? = nil,
        amount: Int? = nil,
        icon: String? = nil,
        strategy: Strategy,
        calculation: Calculation,
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
    
    func calculateEndDateByAmount() -> Date {
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
            icon: icon ?? "square.dashed",
            startDate: Date(),
            endDate: calculation == .Date ? endDate : calculateEndDateByAmount(),
            targetAmount: amount!,
            strategy: strategy
        )
    }
    
    func isValid() -> Bool {
        return name != "" && amount != nil && calculation == .Amount ? cycleAmount != nil : true // && icon != nil
    }
}

enum Strategy: String, CaseIterable {
    case Weekly
    case Monthly
}

enum Calculation: String {
    case Date = "Until Date"
    case Amount = "With Amount"
}

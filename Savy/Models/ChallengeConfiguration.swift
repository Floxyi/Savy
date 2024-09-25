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
    
    init(name: String? = nil, amount: Int? = nil, icon: String? = nil, strategy: Strategy, calculation: Calculation, cycleAmount: Int? = nil, endDate: Date = Date()) {
        self.name = name
        self.amount = amount
        self.icon = icon
        self.strategy = strategy
        self.calculation = calculation
        self.cycleAmount = cycleAmount
        self.endDate = endDate
    }
    
    func calculateEndDateByAmount() -> Date {
        let calendar = Calendar.current
        var date = Date()

        guard let amount = amount, let cycleAmount = cycleAmount, cycleAmount > 0 else {
            return date
        }
        
        let numberOfCycles = amount / cycleAmount

        switch strategy {
        case .Weekly:
            date = calendar.date(byAdding: .weekOfYear, value: numberOfCycles, to: date) ?? date
        case .Monthly:
            date = calendar.date(byAdding: .month, value: numberOfCycles, to: date) ?? date
        }

        return date
    }
    
    func calculateCycleAmount() -> Int? {
        let numberOfCyles = (strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks()) == 0 ? nil : (strategy == .Monthly ? self.numberOfMonths() : self.numberOfWeeks())
        
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
        if calculation == .Date {
            return Challenge(name: name!, icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: amount!, strategy: strategy)
        }
        
        return Challenge(name: name!, icon: "macbook", startDate: Date(), endDate: calculateEndDateByAmount(), targetAmount: amount!, strategy: strategy)
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

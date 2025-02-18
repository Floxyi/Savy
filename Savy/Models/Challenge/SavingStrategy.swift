//
//  SavingStrategy.swift
//  Savy
//
//  Created by Florian Winkler on 29.09.24.
//

import Foundation

/// Enum representing the different saving strategies.
///
/// These strategies determine how frequently the savings should be made:
/// - `Daily`: Savings occur every day.
/// - `Weekly`: Savings occur every week.
/// - `Monthly`: Savings occur every month.
/// - `Quarterly`: Savings occur every 3 months.
/// - `Biannually`: Savings occur every 6 months.
/// - `Annually`: Savings occur once a year.
enum SavingStrategy: String, CaseIterable, Codable {
    case Daily
    case Weekly
    case Monthly
    case Quaterly
    case Biannually
    case Annually

    /// Provides the corresponding calendar component for the strategy.
    ///
    /// - Returns: The `Calendar.Component` that corresponds to the saving strategy.
    var calendarComponent: Calendar.Component {
        switch self {
        case .Daily: .day
        case .Weekly: .weekOfYear
        case .Monthly: .month
        case .Quaterly: .month
        case .Biannually: .month
        case .Annually: .year
        }
    }

    /// The increment for each cycle in the saving strategy.
    ///
    /// - Returns: The number of units to increment for each cycle (e.g., 1 day, 1 month).
    var increment: Int {
        switch self {
        case .Daily: 1
        case .Weekly: 1
        case .Monthly: 1
        case .Quaterly: 3
        case .Biannually: 6
        case .Annually: 1
        }
    }

    /// Provides the localized string representation of the saving strategy.
    ///
    /// - Returns: A localized string describing the saving strategy.
    var localizedString: String {
        switch self {
        case .Daily:
            String(localized: "Daily")
        case .Weekly:
            String(localized: "Weekly")
        case .Monthly:
            String(localized: "Monthly")
        case .Quaterly:
            String(localized: "Quarterly")
        case .Biannually:
            String(localized: "Biannually")
        case .Annually:
            String(localized: "Annually")
        }
    }
}

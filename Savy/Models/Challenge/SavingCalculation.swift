//
//  SavingCalculation.swift
//  Savy
//
//  Created by Florian Winkler on 29.09.24.
//

/// Enum representing the different saving calculation strategies.
///
/// - `Date`: The saving is calculated based on a target date.
/// - `Amount`: The saving is calculated based on a target amount of money.
enum SavingCalculation: String, Codable {
    case Date
    case Amount

    /// Provides the localized string representation of the saving calculation strategy.
    ///
    /// - Returns: A localized string describing the saving calculation strategy.
    var localizedString: String {
        switch self {
        case .Date:
            String(localized: "Until Date")
        case .Amount:
            String(localized: "With Amount")
        }
    }
}

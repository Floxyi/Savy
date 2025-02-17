//
//  StatsType.swift
//  Savy
//
//  Created by Nadine Schatz on 10.10.24.
//

import Foundation

/// Enum representing the different types of statistics that can be tracked.
///
/// This enum is used to categorize the types of stats that are recorded in the system.
/// Each case corresponds to a different event or action, such as money saved or challenges
/// started and completed.
///
/// - `money_saved`: Tracks the amount of money that has been saved.
/// - `challenge_started`: Tracks when a challenge has been started.
/// - `challenge_completed`: Tracks when a challenge has been completed.
enum StatsType: String, CaseIterable, Codable {
    /// Tracks the amount of money saved.
    case money_saved

    /// Tracks when a challenge has started.
    case challenge_started

    /// Tracks when a challenge has been completed.
    case challenge_completed

    /// A computed property that returns a localized string for the stats type.
    ///
    /// - Returns: A localized string corresponding to the stats type.
    var localizedString: String {
        switch self {
        case .money_saved:
            String(localized: "Money saved")
        case .challenge_started:
            String(localized: "Challenge started")
        case .challenge_completed:
            String(localized: "Challenge completed")
        }
    }
}

//
//  StatsType.swift
//  Savy
//
//  Created by Nadine Schatz on 10.10.24.
//

import Foundation

enum StatsType: String, CaseIterable, Codable {
    case money_saved
    case challenge_started
    case challenge_completed

    var localizedString: String {
        switch self {
        case .money_saved:
            String(localized: "Money saved")
        case .challenge_started:
            String(localized: "Challenged started")
        case .challenge_completed:
            String(localized: "Challenged completed")
        }
    }
}

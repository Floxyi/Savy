//
//  SavingStrategy.swift
//  Savy
//
//  Created by Florian Winkler on 29.09.24.
//

import Foundation

enum SavingStrategy: String, CaseIterable, Codable {
    case Daily
    case Weekly
    case Monthly
    case Quaterly
    case Biannually
    case Annualy

    var calendarComponent: Calendar.Component {
        switch self {
        case .Daily: .day
        case .Weekly: .weekOfYear
        case .Monthly: .month
        case .Quaterly: .month
        case .Biannually: .month
        case .Annualy: .year
        }
    }

    var increment: Int {
        switch self {
        case .Daily: 1
        case .Weekly: 1
        case .Monthly: 1
        case .Quaterly: 3
        case .Biannually: 6
        case .Annualy: 1
        }
    }

    var localizedString: String {
        switch self {
        case .Daily:
            String(localized: "Daily")
        case .Weekly:
            String(localized: "Weekly")
        case .Monthly:
            String(localized: "Monthly")
        case .Quaterly:
            String(localized: "Quaterly")
        case .Biannually:
            String(localized: "Biannually")
        case .Annualy:
            String(localized: "Annualy")
        }
    }
}

//
//  SavingCalculation.swift
//  Savy
//
//  Created by Florian Winkler on 29.09.24.
//

enum SavingCalculation: String, Codable {
    case Date
    case Amount

    var localizedString: String {
        switch self {
        case .Date:
            String(localized: "Until Date")
        case .Amount:
            String(localized: "With Amount")
        }
    }
}

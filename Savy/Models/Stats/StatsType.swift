//
//  StatsType.swift
//  Savy
//
//  Created by Nadine Schatz on 10.10.24.
//

import Foundation

enum StatsType: String, CaseIterable, Codable {
    case money_saved = "Money saved"
    case challenge_started = "Challenged started"
    case challenge_completed = "Challenged completed"
}

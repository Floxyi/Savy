//
//  ProfileWithSavings.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation

struct ProfileWithSavings: Codable, Identifiable {
    let id: UUID
    let username: String
    let savings: Savings

    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case username
        case savings
    }
}

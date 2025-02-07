//
//  Savings.swift
//  Savy
//
//  Created by Florian Winkler on 14.10.24.
//

import Foundation

struct Savings: Codable {
    let profileId: UUID
    var amount: Int

    enum CodingKeys: String, CodingKey {
        case profileId = "profile_id"
        case amount
    }
}

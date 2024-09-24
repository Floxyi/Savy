//
//  User.swift
//  Savy
//
//  Created by Florian Winkler on 29.08.24.
//

import Foundation

struct Profile: Codable, Identifiable {
    let id: UUID
    let username: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case username
    }
}

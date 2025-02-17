//
//  ProfileWithSavings.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation

/// A user profile that includes savings data.
///
/// The `ProfileWithSavings` struct represents a user profile with a unique identifier,
/// a username, and an associated savings object. It conforms to `Codable` for easy encoding
/// and decoding, and `Identifiable` for use in SwiftUI lists.
struct ProfileWithSavings: Codable, Identifiable {
    /// The unique identifier of the profile.
    let id: UUID

    /// The username associated with the profile.
    let username: String

    /// The savings data linked to this profile.
    let savings: Savings

    /// Coding keys used for encoding and decoding.
    ///
    /// - `id`: Mapped to `"uuid"` in JSON.
    /// - `username`: Mapped directly as `"username"`.
    /// - `savings`: Mapped directly as `"savings"`.
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case username
        case savings
    }
}

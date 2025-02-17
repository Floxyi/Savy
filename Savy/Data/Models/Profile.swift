//
//  Profile.swift
//  Savy
//
//  Created by Florian Winkler on 29.08.24.
//

import Foundation

/// A user profile representation.
///
/// The `Profile` struct stores basic user information, including a unique identifier and an optional username.
/// It conforms to `Codable` for easy encoding and decoding, and `Identifiable` for use in SwiftUI lists.
struct Profile: Codable, Identifiable {
    /// The unique identifier of the profile.
    let id: UUID

    /// The username associated with the profile.
    let username: String

    /// Coding keys used for encoding and decoding.
    ///
    /// - `id`: Mapped to `"uuid"` in JSON.
    /// - `username`: Mapped directly as `"username"`.
    enum CodingKeys: String, CodingKey {
        case id = "uuid"
        case username
    }
}

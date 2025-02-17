//
//  Savings.swift
//  Savy
//
//  Created by Florian Winkler on 14.10.24.
//

import Foundation

/// Represents the savings associated with a user profile.
///
/// The `Savings` struct stores financial savings data, linking it to a specific profile
/// via a unique identifier. It conforms to `Codable` for easy encoding and decoding.
struct Savings: Codable {
    /// The unique identifier of the associated profile.
    let profileId: UUID

    /// The total savings amount.
    ///
    /// This value represents the user's saved amount, stored as an integer (e.g., in cents or whole units).
    var amount: Int

    /// Coding keys used for encoding and decoding.
    ///
    /// - `profileId`: Mapped to `"profile_id"` in JSON.
    /// - `amount`: Mapped directly as `"amount"`.
    enum CodingKeys: String, CodingKey {
        case profileId = "profile_id"
        case amount
    }
}

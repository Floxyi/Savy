//
//  SavingsService.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

/// A service responsible for managing savings data in Supabase.
///
/// The `SavingsService` class provides methods to retrieve and update savings
/// information associated with user profiles.
class SavingsService {
    /// The shared singleton instance of `SavingsService`.
    static let shared = SavingsService()

    /// The Supabase client instance used for database interactions.
    private let client = SupabaseClientProvider.shared.client

    /// Private initializer to enforce the singleton pattern.
    private init() {}

    /// Retrieves all savings entries from the database.
    ///
    /// - Returns: An array of `Savings` objects.
    /// - Throws: An error if the database query fails.
    func getAllSavings() async throws -> [Savings] {
        try await client
            .from("savings")
            .select()
            .execute()
            .value
    }

    /// Retrieves the savings entry for a specific user profile.
    ///
    /// - Parameter profileId: The unique identifier of the profile.
    /// - Returns: A `Savings` object containing the profile’s savings data.
    /// - Throws: An error if the database query fails or no entry is found.
    func getSavings(profileId: UUID) async throws -> Savings {
        try await client
            .from("savings")
            .select()
            .eq("profile_id", value: profileId)
            .single()
            .execute()
            .value
    }

    /// Updates the savings amount for a specific user profile.
    ///
    /// This method updates the `amount` field of a savings entry
    /// associated with the given profile ID.
    ///
    /// - Parameters:
    ///   - amount: The new savings amount.
    ///   - profileId: The unique identifier of the profile.
    /// - Throws: An error if the database update fails.
    func updateSavingsAmount(amount: Int, profileId: UUID) async throws {
        try await client
            .from("savings")
            .update(["amount": amount])
            .eq("profile_id", value: profileId)
            .execute()
    }
}

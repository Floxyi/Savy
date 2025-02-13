//
//  SavingsService.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

class SavingsService {
    static let shared = SavingsService()
    private let client = SupabaseClientProvider.shared.client

    private init() {}

    func getAllSavings() async throws -> [Savings] {
        try await client
            .from("savings")
            .select()
            .execute()
            .value
    }

    func getSavings(profileId: UUID) async throws -> Savings {
        try await client
            .from("savings")
            .select()
            .eq("profile_id", value: profileId)
            .single()
            .execute()
            .value
    }

    func updateSavingsAmount(amount: Int, profileId: UUID) async throws {
        try await client
            .from("savings")
            .update(["amount": amount])
            .eq("profile_id", value: profileId)
            .execute()
    }
}

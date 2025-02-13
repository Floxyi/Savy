//
//  ProfileService.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

class ProfileService {
    static let shared = ProfileService()
    private let client = SupabaseClientProvider.shared.client

    private init() {}

    func createProfile(uuid: UUID, username: String, statsService: StatsService) async throws -> Profile {
        let profileEntry = Profile(id: uuid, username: username)
        let savingsEntry = Savings(profileId: uuid, amount: statsService.totalMoneySaved())

        try await client.from("profiles").insert(profileEntry).execute()
        try await client.from("savings").insert(savingsEntry).execute()

        return profileEntry
    }

    func getProfile(uuid: UUID) async throws -> Profile? {
        try await client
            .from("profiles")
            .select()
            .eq("uuid", value: uuid)
            .single()
            .execute()
            .value
    }

    func getAllProfiles() async throws -> [Profile] {
        try await client
            .from("profiles")
            .select()
            .execute()
            .value
    }

    func getProfileWithAmount(uuid: UUID) async throws -> ProfileWithSavings {
        try await client
            .from("profiles")
            .select("id, username, savings(amount)")
            .eq("uuid", value: uuid)
            .single()
            .execute()
            .value
    }

    func getAllProfilesWithSavings() async throws -> [ProfileWithSavings] {
        try await client
            .from("profiles")
            .select("uuid, username, savings(profile_id, amount)")
            .execute()
            .value
    }
}

//
//  SupabaseClientProvider.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

/// A singleton provider for the Supabase client.
///
/// The `SupabaseClientProvider` is responsible for initializing and
/// providing a shared instance of `SupabaseClient` for database interactions.
class SupabaseClientProvider {
    /// The shared singleton instance of `SupabaseClientProvider`.
    static let shared = SupabaseClientProvider()

    /// The Supabase client instance used for API requests.
    let client: SupabaseClient

    /// Private initializer to enforce the singleton pattern.
    ///
    /// This initializer retrieves the Supabase URL and anonymous key
    /// from the `DotEnv` configuration and initializes the `SupabaseClient`.
    private init() {
        let (url, key) = (DotEnv.SUPABASE_URL, DotEnv.SUPABASE_ANON_KEY)
        client = SupabaseClient(supabaseURL: URL(string: url)!, supabaseKey: key)
    }
}

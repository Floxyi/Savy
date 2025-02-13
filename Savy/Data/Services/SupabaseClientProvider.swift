//
//  SupabaseClientProvider.swift
//  Savy
//
//  Created by Florian Winkler on 07.02.25.
//

import Foundation
import Supabase

class SupabaseClientProvider {
    static let shared = SupabaseClientProvider()

    let client: SupabaseClient

    private init() {
        let (url, key) = (DotEnv.SUPABASE_URL, DotEnv.SUPABASE_ANON_KEY)
        client = SupabaseClient(supabaseURL: URL(string: url)!, supabaseKey: key)
    }
}

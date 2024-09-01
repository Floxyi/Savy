//
//  Supabase.swift
//  Savy
//
//  Created by Florian Winkler on 29.08.24.
//

import Foundation
import Supabase

let supabase = AppEnvironment.current == .production ?
    SupabaseClient(supabaseURL: URL(string: DotEnv.PROD_SUPABASE_URL)!, supabaseKey: DotEnv.PROD_SUPABASE_ANON_KEY) :
    SupabaseClient(supabaseURL: URL(string: DotEnv.DEV_SUPABASE_URL)!, supabaseKey: DotEnv.DEV_SUPABASE_ANON_KEY)

enum DotEnv {
    static let SUPABASE_ANON_KEY: String = switch AppEnvironment.current {
    case .development:
        ""
    case .production:
        ""
    }

    static let SUPABASE_URL: String = switch AppEnvironment.current {
    case .development:
        ""
    case .production:
        ""
    }
}

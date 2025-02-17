//
//  AppEnvironment.swift
//  Savy
//
//  Created by Florian Winkler on 31.08.24.
//

import Foundation

/// Enum that defines the app's environment (development or production).
///
/// The `AppEnvironment` enum is used to differentiate between the development and production environments
/// based on the build configuration. This allows the app to adapt its behavior depending on whether it's
/// running in development or production mode.
///
/// - `development`: Represents the development environment where debugging and testing are active.
/// - `production`: Represents the production environment where the app is in its release state.

enum AppEnvironment {
    case development
    case production

    /// The current environment based on the build configuration.
    ///
    /// - Returns: The current environment, either `.development` or `.production`.
    static let current: AppEnvironment = {
        #if DEBUG
            .development // If in DEBUG mode, the environment is development.
        #else
            return .production // In other configurations (like Release), it's production.
        #endif
    }()
}

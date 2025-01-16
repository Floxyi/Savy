//
//  AppEnvironment.swift
//  Savy
//
//  Created by Florian Winkler on 31.08.24.
//

import Foundation

enum AppEnvironment {
    case development
    case production

    static let current: AppEnvironment = {
        #if DEBUG
        .development
        #else
        return .production
        #endif
    }()
}

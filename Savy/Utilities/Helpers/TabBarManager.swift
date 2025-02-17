//
//  TabBarManager.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

/// A manager for handling the state and interactions with the app's tab bar.
class TabBarManager: ObservableObject {
    /// A singleton instance of the `TabBarManager` to be shared across the app.
    static var shared = TabBarManager()

    /// The currently selected tab in the app's tab bar.
    @Published var selectedTab: Tab = .challenges

    /// A flag indicating whether the tab bar is shown or hidden.
    @Published private(set) var isShown: Bool = true

    /// Hides the tab bar.
    func hide() {
        isShown = false
    }

    /// Shows the tab bar.
    func show() {
        isShown = true
    }

    /// Switches to a specific tab and provides haptic feedback.
    ///
    /// - Parameter tab: The `Tab` to switch to.
    func switchTab(tab: Tab) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        selectedTab = tab
    }
}

/// Enum representing the available tabs in the tab bar.
enum Tab: String, Hashable, CaseIterable {
    case challenges = "calendar"
    case leaderboard = "trophy"
    case settings = "gear"
}

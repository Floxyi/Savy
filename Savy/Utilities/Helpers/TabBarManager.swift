//
//  TabBarManager.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftUI

class TabBarManager: ObservableObject {
    static var shared = TabBarManager()

    @Published var selectedTab: Tab = .challenges
    @Published private(set) var isShown: Bool = true

    func hide() {
        isShown = false
    }

    func show() {
        isShown = true
    }

    func switchTab(tab: Tab) {
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        selectedTab = tab
    }
}

enum Tab: String, Hashable, CaseIterable {
    case challenges = "calendar"
    case leaderboard = "trophy"
    case settings = "gear"
}

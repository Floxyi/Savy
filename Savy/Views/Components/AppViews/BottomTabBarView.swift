//
//  BottomTabBarView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftData
import SwiftUI

private let buttonDimen: CGFloat = 55

struct BottomTabBarView: View {
    @StateObject private var tabBarManager = TabBarManager.shared
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            TabBarButton(tab: Tab.challenges, active: tabBarManager.selectedTab == Tab.challenges)
            Spacer()
            TabBarButton(tab: Tab.leaderboard, active: tabBarManager.selectedTab == Tab.leaderboard)
            Spacer()
            TabBarButton(tab: Tab.settings, active: tabBarManager.selectedTab == Tab.settings)
        }
        .frame(width: 300, height: 70)
        .tint(Color.black)
        .padding(.vertical, 2.5)
        .background(currentScheme.bar)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
}

private struct TabBarButton: View {
    let tab: Tab
    let active: Bool

    @StateObject private var tabBarManager = TabBarManager.shared
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Image(systemName: tab.rawValue)
            .renderingMode(.template)
            .foregroundStyle(active ? currentScheme.font : currentScheme.barIcons)
            .fontWeight(.bold)
            .font(.system(size: active ? 40 : 24))
            .animation(.easeOut, value: active)
            .frame(width: buttonDimen, height: buttonDimen)
            .onTapGesture { tabBarManager.switchTab(tab: tab) }
            .padding(.horizontal, 16)
    }
}

#Preview {
    let schema = Schema([ColorService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)

    return BottomTabBarView()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
}

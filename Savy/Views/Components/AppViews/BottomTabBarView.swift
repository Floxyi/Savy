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
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel
    @Binding var currentTab: Tab

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            TabBarButton(imageName: Tab.challenges.rawValue, active: currentTab == Tab.challenges)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentTab = .challenges
                }
                .padding(.horizontal, 16)

            Spacer()

            TabBarButton(imageName: Tab.leaderboard.rawValue, active: currentTab == Tab.leaderboard)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentTab = .leaderboard
                }
                .padding(.horizontal, 16)

            Spacer()

            TabBarButton(imageName: Tab.settings.rawValue, active: currentTab == Tab.settings)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentTab = .settings
                }
                .padding(.horizontal, 16)
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
    let imageName: String
    let active: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Image(systemName: imageName)
            .renderingMode(.template)
            .foregroundStyle(active ? currentScheme.font : currentScheme.barIcons)
            .fontWeight(.bold)
            .font(.system(size: active ? 40 : 24))
            .animation(.easeInOut, value: active)
    }
}

#Preview {
    @Previewable @State var selectedTab = Tab.challenges
    return BottomTabBarView(currentTab: $selectedTab)
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

//
//  BottomTabBarView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI
import SwiftData


private let buttonDimen: CGFloat = 55

struct BottomTabBarView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    @Binding var currentTab: Tab
    
    var body: some View {
        HStack {
            TabBarButton(imageName: Tab.challenges.rawValue, active: currentTab == Tab.challenges)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentTab = .challenges
                }
                .padding(.horizontal, 8)
            
            Spacer()

            TabBarButton(imageName: Tab.leaderboard.rawValue, active: currentTab == Tab.leaderboard)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentTab = .leaderboard
                }
                .padding(.horizontal, 8)

            Spacer()
            
            TabBarButton(imageName: Tab.settings.rawValue, active: currentTab == Tab.settings)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    currentTab = .settings
                }
                .padding(.horizontal, 8)

        }
        .frame(width: (buttonDimen * CGFloat(Tab.allCases.count)) + 80)
        .tint(Color.black)
        .padding(.vertical, 2.5)
        .background(colorManagerVM.colorManager.currentSchema.bar)
        .clipShape(Capsule(style: .continuous))
        .shadow(color: colorManagerVM.colorManager.currentSchema.bar.opacity(0.5), radius: 5, x: 0, y: 5)
    }
    
}

private struct TabBarButton: View {
    let imageName: String
    let active: Bool

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.template)
            .foregroundStyle(colorManagerVM.colorManager.currentSchema.barIcons)
            .fontWeight(.bold)
            .font(.system(size: active ? 30 : 20))
            .scaleEffect(active ? 1.1 : 1.0)
            .animation(.easeInOut, value: active)
    }
}

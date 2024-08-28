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
        let currentSchema = colorManagerVM.colorManager.currentSchema

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
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.25), radius: 4, x: 0, y: 4)
    }
    
}

private struct TabBarButton: View {
    let imageName: String
    let active: Bool

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Image(systemName: imageName)
            .renderingMode(.template)
            .foregroundStyle(active ? currentSchema.font : currentSchema.barIcons)
            .fontWeight(.bold)
            .font(.system(size: active ? 40 : 24))
            .animation(.easeInOut, value: active)
    }
}

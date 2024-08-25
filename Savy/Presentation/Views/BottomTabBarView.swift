//
//  BottomTabBarView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI

private let buttonDimen: CGFloat = 55

struct BottomTabBarView: View {
    
    @Binding var currentTab: Tab
    
    var body: some View {
        HStack {
            TabBarButton(imageName: Tab.challenges.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .challenges
                }
            
            Spacer()

            TabBarButton(imageName: Tab.leaderboard.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .leaderboard
                }

            Spacer()
            
            TabBarButton(imageName: Tab.settings.rawValue)
                .frame(width: buttonDimen, height: buttonDimen)
                .onTapGesture {
                    currentTab = .settings
                }

        }
        .frame(width: (buttonDimen * CGFloat(Tab.allCases.count)) + 60)
        .tint(Color.black)
        .padding(.vertical, 2.5)
        .background(Color.white)
        .clipShape(Capsule(style: .continuous))
        .shadow(color: Color.gray.opacity(0.5), radius: 5, x: 0, y: 10)
        .animation(.interactiveSpring(response: 0.5, dampingFraction: 0.65, blendDuration: 0.65), value: currentTab)
    }
    
}

private struct TabBarButton: View {
    let imageName: String
    var body: some View {
        Image(systemName: imageName)
            .renderingMode(.template)
            .tint(.black)
            .fontWeight(.bold)
    }
}

//
//  TabbedView.swift
//  Savy
//
//  Created by Florian Winkler on 25.08.24.
//

import SwiftUI

enum TabbedItems: Int, CaseIterable{
    case challenges = 0
    case leaderboard
    case settings
    
    var iconName: String {
        switch self {
        case .challenges:
            return "calendar"
        case .leaderboard:
            return "trophy"
        case .settings:
            return "gear"
        }
    }
}

struct TabbedView: View {
    
    @State var selectedTab = 0
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
                ChallengesScreen()
                    .tag(0)

                LeaderboardScreen()
                    .tag(1)

                SettingsScreen()
                    .tag(2)
            }

            ZStack{
                HStack{
                    ForEach((TabbedItems.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.iconName, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.purple.opacity(0.2))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

extension TabbedView {
    func CustomTabItem(imageName: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(isActive ? .purple.opacity(0.4) : .clear)
        .cornerRadius(30)
    }
}

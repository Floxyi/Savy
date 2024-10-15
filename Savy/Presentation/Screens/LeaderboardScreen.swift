//
//  LeaderboardScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct LeaderboardScreen: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    @State var showsPersonalStats: Bool = false
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            if showsPersonalStats {
                PersonalStatsView()
            }
            
            if !showsPersonalStats {
                LeaderboardView()
            }
            
            Spacer()
            LeaderboardSwitchButton(showsPersonalStats: $showsPersonalStats)
                .padding(.bottom, 100)
            
            HStack {
                Spacer()
            }
        }
        .padding()
        .background(currentSchema.background)
    }
}

#Preview {
    LeaderboardScreen()
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

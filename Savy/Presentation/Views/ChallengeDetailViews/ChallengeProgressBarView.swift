//
//  ProgressBar.swift
//  Savy
//
//  Created by Florian Winkler on 25.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeProgressBarView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    let challenge: Challenge
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let progress = CGFloat(challenge.progressPercentage())
        
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(currentSchema.accent1)
                    .frame(height: geometry.size.height)
                
                RoundedRectangle(cornerRadius: geometry.size.height / 2)
                    .fill(currentSchema.barIcons)
                    .frame(width: geometry.size.width * progress, height: geometry.size.height)
                
                HStack {
                    Image(systemName: challenge.icon)
                        .foregroundColor(currentSchema.accent2)
                    
                    Spacer()
                    
                    Text("\(challenge.currentSavedAmount())€")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                    
                    Spacer()
                    
                    Text("\(challenge.targetAmount)€")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                }
                .padding(.horizontal, 10)
            }
        }
        .frame(height: 30)
    }
}

#Preview {
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    let challenge: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500)
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeProgressBarView(challenge: challenge)
        .padding()
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}

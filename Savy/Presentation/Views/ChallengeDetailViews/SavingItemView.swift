//
//  SavingItemView.swift
//  Savy
//
//  Created by Florian Winkler on 05.09.24.
//

import SwiftData
import SwiftUI

struct SavingItemView: View {
    let saving: Saving
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        VStack {
            Text(saving.date.formatted(.dateTime.month(.twoDigits).day()))
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(currentSchema.font)
                .frame(width: 50)
                .padding(4)
                .background(currentSchema.background)
                .clipShape(RoundedRectangle(cornerRadius: 25))
                .padding(.bottom, -6)
            
            Text("\(saving.amount)€")
                .font(.system(size: 26, weight: .bold))
                .foregroundStyle(currentSchema.font)
        }
        .frame(width: 80, height: 80)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .onTapGesture {
            withAnimation {
                saving.markAsDone()
            }
        }
    }
}

#Preview {
    let saving: Saving = Saving(challengeId: UUID(), amount: 30, date: Date(), done: false)
    
    let container = try! ModelContainer(for: Saving.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(saving)
    
    return SavingItemView(saving: saving)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
        .environmentObject(TabBarManager())
}

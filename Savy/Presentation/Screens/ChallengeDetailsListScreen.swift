//
//  ChallengeDetailsListScreen.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftUI
import SwiftData

struct ChallengeDetailsListScreen: View {
    let challenge: Challenge
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        let columns = Array(repeating: GridItem(.flexible()), count: 4)
        
        NavigationStack {
            VStack {
                Text("Savings")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(currentSchema.font)
                
                HStack {
                    Text("From: ")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentSchema.font)
                    Text(challenge.startDate.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 16))
                        .foregroundColor(currentSchema.font)
                    Spacer()
                    Text("Until: ")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(currentSchema.font)
                    Text(challenge.endDate.formatted(.dateTime.day().month().year()))
                        .font(.system(size: 16))
                        .foregroundColor(currentSchema.font)
                }
                .padding(.horizontal, 26)
                .padding(.top, 1)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(challenge.savings, id: \.id) { saving in
                            SavingItemView(saving: saving)
                        }
                    }
                }
                .padding(.top, 20)
                .background(currentSchema.background)
                
                Spacer()
                HStack {
                    Spacer()
                }
            }
            .padding()
            .background(currentSchema.background)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    ToolbarDoneButton(
                        showPopover: $showPopover,
                        isValid: { return true },
                        onDoneAction: { }
                    )
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var showPopover: Bool = true
    
    let endDate = Calendar.current.date(byAdding: .month, value: 48, to: Date())!
    let challenge: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 200, strategy: .Monthly)
    
    return Spacer()
        .popover(isPresented: $showPopover) {
            ChallengeDetailsListScreen(challenge: challenge, showPopover: $showPopover)
        }
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

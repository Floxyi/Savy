//
//  ChallengeListItemView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeListItemView: View {
    var challenge: Challenge
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        NavigationLink(destination: ChallengeDetailScreen(challenge: challenge)) {
            VStack {
                HStack {
                    Image(systemName: challenge.icon)
                        .fontWeight(.bold)
                        .foregroundStyle(currentSchema.accent2)
                    Text(challenge.name)
                        .fontWeight(.bold)
                        .foregroundStyle(currentSchema.accent2)
                    Spacer()
                    Text(challenge.endDate.formatted(.dateTime.month(.wide).day()))
                        .foregroundStyle(currentSchema.accent2)
                        .font(.system(size: 13))
                    Image(systemName: "calendar")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(currentSchema.accent2)
                }
                .padding(.bottom, 12)
                HStack {
                    VStack {
                        Text("\(challenge.getNextSaving().amount.formatted())€")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(currentSchema.background)
                        Text(challenge.getNextSaving().date.formatted(.dateTime.month(.twoDigits).day()))
                            .font(.system(size: 12))
                            .foregroundStyle(currentSchema.background)
                    }
                    .frame(width: 42, height: 42)
                    .padding(4)
                    .background(currentSchema.font)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    VStack {
                        Divider()
                            .frame(width: 16, height: 2)
                            .background(currentSchema.font)
                    }
                    .padding(.horizontal, -8)
                    VStack {
                        Text("\(challenge.getNextNextSaving().amount.formatted())€")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(currentSchema.font)
                        Text(challenge.getNextNextSaving().date.formatted(.dateTime.month(.twoDigits).day()))
                            .font(.system(size: 12))
                            .foregroundStyle(currentSchema.font)
                    }
                    .frame(width: 42, height: 42)
                    .padding(4)
                    .background(.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2))
                            .foregroundColor(currentSchema.font)
                    )
                    VStack {
                        Divider()
                            .frame(width: 16, height: 2)
                            .background(currentSchema.font)
                    }
                    .padding(.horizontal, -8)
                    VStack {
                        Text("\(challenge.remainingSavings())x")
                            .font(.system(size: 14))
                            .foregroundStyle(currentSchema.font)
                        Text("to go")
                            .font(.system(size: 14))
                            .foregroundStyle(currentSchema.font)
                    }
                    .frame(width: 42, height: 42)
                    .padding(4)
                    .background(.clear)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                            .foregroundColor(currentSchema.font)
                    )
                    Spacer()
                    HStack {
                        Text("\(challenge.currentSavedAmount())€")
                            .padding(.trailing, -4)
                            .font(.system(size: 16, weight: .bold))
                            .foregroundStyle(currentSchema.font)
                        Text("/ \(challenge.targetAmount)€")
                            .padding(.bottom, -2)
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(currentSchema.accent2)
                    }
                    .padding(8)
                    .background(currentSchema.accent1)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                }
            }
            .padding(16)
            .background(currentSchema.bar)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .listRowBackground(Color(.secondarySystemBackground))
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

#Preview {
    let endDate = Calendar.current.date(byAdding: .month, value: 24, to: Date())!
    let challenge: Challenge = Challenge(name: "MacBook", icon: "macbook", startDate: Date(), endDate: endDate, targetAmount: 1500, strategy: .Monthly)
    
    let container = try! ModelContainer(for: Challenge.self, ColorManager.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    container.mainContext.insert(challenge)
    
    return ChallengeListItemView(challenge: challenge)
        .modelContainer(container)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(container)))
}

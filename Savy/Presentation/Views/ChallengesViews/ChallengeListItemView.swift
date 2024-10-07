//
//  ChallengeListItemView.swift
//  Savy
//
//  Created by Florian Winkler on 03.09.24.
//

import SwiftData
import SwiftUI

struct ChallengeListItemView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        NavigationLink(destination: ChallengeDetailScreen(challenge: challenge)) {
            VStack(spacing: 12) {
                HeadlineView(challenge: challenge)
                ProgressView(challenge: challenge)
            }
            .padding(16)
            .background(colorManagerVM.colorManager.currentSchema.bar)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .listRowBackground(Color(.secondarySystemBackground))
        .padding(.horizontal)
        .padding(.bottom, 16)
    }
}

private struct HeadlineView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack {
            IconAndNameView(challenge: challenge)
            Spacer()
            DateView(date: challenge.endDate)
        }
    }
}

private struct IconAndNameView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack {
            Image(systemName: challenge.icon)
                .fontWeight(.bold)
            Text(challenge.name)
                .fontWeight(.bold)
        }
        .foregroundStyle(colorManagerVM.colorManager.currentSchema.accent2)
    }
}

private struct DateView: View {
    let date: Date
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack {
            Text(date.formatted(.dateTime.month(.wide).day()))
            Image(systemName: "calendar")
        }
        .font(.system(size: 13, weight: .bold))
        .foregroundStyle(colorManagerVM.colorManager.currentSchema.accent2)
    }
}

private struct ProgressView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack {
            if challenge.remainingSavings() != 0 {
                SavingsProgressView(challenge: challenge)
            } else {
                FinishedView()
            }
            Spacer()
            AmountView(challenge: challenge)
        }
    }
}

private struct SavingsProgressView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack(spacing: -8) {
            NextSavingView(saving: challenge.getNextSaving(), isNext: true)
            if challenge.remainingSavings() >= 2 {
                Divider()
                    .frame(width: 16, height: 2)
                    .background(colorManagerVM.colorManager.currentSchema.font)
                    .padding(.horizontal, 8)
                NextSavingView(saving: challenge.getNextNextSaving(), isNext: false)
            }
            Divider()
                .frame(width: 16, height: 2)
                .background(colorManagerVM.colorManager.currentSchema.font)
                .padding(.horizontal, 8)
            RemainingView(remainingSavings: challenge.remainingSavings())
        }
    }
}

private struct NextSavingView: View {
    let saving: Saving
    let isNext: Bool
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        VStack {
            Text("\(saving.amount.formatted())€")
                .font(.system(size: 14, weight: .bold))
            Text(saving.date.formatted(.dateTime.month(.twoDigits).day()))
                .font(.system(size: 12))
        }
        .frame(width: 42, height: 42)
        .padding(4)
        .background(isNext ? colorManagerVM.colorManager.currentSchema.font : .clear)
        .foregroundStyle(isNext ? colorManagerVM.colorManager.currentSchema.background : colorManagerVM.colorManager.currentSchema.font)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2))
                .foregroundColor(colorManagerVM.colorManager.currentSchema.font)
                .opacity(isNext ? 0 : 1)
        )
    }
}

private struct RemainingView: View {
    let remainingSavings: Int
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        VStack {
            if remainingSavings > 2 {
                Text("\(remainingSavings - 2)x")
                Text("to go")
            } else {
                Image(systemName: "flag.2.crossed")
                Text("done")
            }
        }
        .font(.system(size: 14))
        .frame(width: 42, height: 42)
        .padding(4)
        .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(style: StrokeStyle(lineWidth: 2, dash: [5]))
                .foregroundColor(colorManagerVM.colorManager.currentSchema.font)
        )
    }
}

private struct FinishedView: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "flag.pattern.checkered.2.crossed")
            Text("Finished!")
            Image(systemName: "flag.pattern.checkered.2.crossed")
        }
        .font(.system(size: 18))
        .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)
    }
}

private struct AmountView: View {
    let challenge: Challenge
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        HStack(alignment: .bottom, spacing: -4) {
            Text("\(challenge.currentSavedAmount())€")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(colorManagerVM.colorManager.currentSchema.font)
                .padding(.trailing, 7)
            Text("/ \(challenge.targetAmount)€")
                .font(.system(size: 10, weight: .bold))
                .foregroundStyle(colorManagerVM.colorManager.currentSchema.accent2)
                .offset(y: -3)
        }
        .padding(8)
        .background(colorManagerVM.colorManager.currentSchema.accent1)
        .clipShape(RoundedRectangle(cornerRadius: 25))
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

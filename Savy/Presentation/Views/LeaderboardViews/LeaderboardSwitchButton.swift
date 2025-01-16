//
//  LeaderboardSwitchButton.swift
//  Savy
//
//  Created by Florian Winkler on 14.10.24.
//

import SwiftUI
import SwiftData

struct LeaderboardSwitchButton: View {
    @Binding var showsPersonalStats: Bool

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        HStack {
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentSchema.font)
            Text(showsPersonalStats ? "Leaderboard" : "Personal Stats")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentSchema.font)
                .padding(.trailing, 2)
        }
        .frame(width: 200, height: 26)
        .padding(8)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.top, 40)
        .onTapGesture {
            showsPersonalStats.toggle()
        }
    }
}

#Preview {
    @Previewable @State var showsPersonalStats: Bool = true

    return LeaderboardSwitchButton(showsPersonalStats: $showsPersonalStats)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

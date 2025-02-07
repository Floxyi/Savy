//
//  LeaderboardSwitchButton.swift
//  Savy
//
//  Created by Florian Winkler on 14.10.24.
//

import SwiftData
import SwiftUI

struct LeaderboardSwitchButton: View {
    @Binding var showsPersonalStats: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentScheme.font)
            Text(showsPersonalStats ? "Leaderboard" : "Personal Stats")
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentScheme.font)
                .padding(.trailing, 2)
        }
        .frame(width: 200, height: 26)
        .padding(8)
        .background(currentScheme.bar)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.top, 40)
        .onTapGesture {
            showsPersonalStats.toggle()
        }
    }
}

#Preview {
    @Previewable @State var showsPersonalStats = true

    return LeaderboardSwitchButton(showsPersonalStats: $showsPersonalStats)
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

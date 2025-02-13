//
//  ChallengeDetailsButtonView.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftData
import SwiftUI

struct ChallengeDetailsButtonView: View {
    var title: String
    var icon: String
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentScheme.font)
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentScheme.font)
                .padding(.trailing, 2)
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background(currentScheme.bar)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.top, 40)
        .onTapGesture {
            showPopover.toggle()
        }
    }
}

#Preview {
    @Previewable @State var showPopover = true

    return ChallengeDetailsButtonView(title: "View all", icon: "chevron.up", showPopover: $showPopover)
        .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

//
//  ChallengeDetailsButtonView.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftUI
import SwiftData

struct ChallengeDetailsButtonView: View {
    var title: String
    var icon: String
    @Binding var showPopover: Bool

    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel

    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema

        HStack {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentSchema.font)
            Text(title)
                .font(.system(size: 16, weight: .bold))
                .foregroundStyle(currentSchema.font)
                .padding(.trailing, 2)
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.top, 40)
        .onTapGesture {
            showPopover.toggle()
        }
    }
}

#Preview {
    @Previewable @State var showPopover: Bool = true

    return ChallengeDetailsButtonView(title: "View all", icon: "chevron.up", showPopover: $showPopover)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

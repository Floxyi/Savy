//
//  ChallengeDetailsButtonView.swift
//  Savy
//
//  Created by Florian Winkler on 11.10.24.
//

import SwiftUI
import SwiftData

struct ChallengeDetailsButtonView: View {
    @Binding var showPopover: Bool
        
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            Image(systemName: "chevron.up")
                .font(.system(size: 24, weight: .bold))
                .foregroundStyle(currentSchema.font)
            Text("Show all")
                .font(.system(size: 18, weight: .bold))
                .foregroundStyle(currentSchema.font)
                .padding(.trailing, 2)
        }
        .padding(.horizontal, 8)
        .padding(8)
        .background(currentSchema.bar)
        .clipShape(RoundedRectangle(cornerRadius: 25))
        .padding(.top, 40)
        .onTapGesture {
            showPopover = true
        }
    }
}

#Preview {
    @Previewable @State var showPopover: Bool = true
    
    return ChallengeDetailsButtonView(showPopover: $showPopover)
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

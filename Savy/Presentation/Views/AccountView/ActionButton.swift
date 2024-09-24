//
//  ActionButton.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//


import SwiftData
import SwiftUI

struct ActionButton: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    let text: String
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            Text(text)
                .foregroundStyle(isEnabled ? currentSchema.font : currentSchema.accent1)
                .font(.system(size: 26))
                .fontWeight(.bold)
            Image(systemName: "arrow.right")
                .foregroundStyle(isEnabled ? currentSchema.font : currentSchema.accent1)
                .fontWeight(.bold)
                .font(.system(size: 20))
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 28)
        .background(currentSchema.bar)
        .cornerRadius(12)
        .onTapGesture {
            if isEnabled {
                action()
            }
        }
    }
}

#Preview {
    ActionButton(text: "Action", isEnabled: true, action: {})
        .modelContainer(for: [ColorManager.self])
        .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

//
//  ActionButton.swift
//  Savy
//
//  Created by Florian Winkler on 23.09.24.
//


import SwiftData
import SwiftUI

struct ActionButton<Content: View>: View {
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    let content: Content
    let isEnabled: Bool
    let action: () -> Void
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        HStack {
            content
                .foregroundStyle(isEnabled ? currentSchema.font : currentSchema.accent1)
        }
        .frame(width: 140)
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

#Preview("Text Button") {
    ActionButton(
        content: HStack {
            Text("Login")
                .font(.system(size: 26))
                .fontWeight(.bold)
            Image(systemName: "arrow.right")
                .fontWeight(.bold)
                .font(.system(size: 20))
        },
        isEnabled: true,
        action: {}
    )
    .modelContainer(for: [ColorManager.self])
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

#Preview("Loading Button") {
    ActionButton(
        content: HStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .frame(width: 20, height: 20)
        },
        isEnabled: true,
        action: {}
    )
    .modelContainer(for: [ColorManager.self])
    .environmentObject(ColorManagerViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorManager.self))))
}

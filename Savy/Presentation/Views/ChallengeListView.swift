//
//  ChallengeListView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct ChallengesListView: View {
    let challenges: [Challenge]
    
    @Environment(\.modelContext) private var modelContext

    @State private var showPopover = false

    var body: some View {
        VStack(alignment: .center) {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(challenges) { challenge in
                    ChallengeListItem(challenge: challenge)
                }
                .onDelete(perform: deleteItems)
            }
            
            AddButton(showPopover: $showPopover)
        }
        .popover(isPresented: $showPopover) {
            ChallengeAddView(showPopover: $showPopover)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(challenges[index])
                do {
                    try modelContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

struct ChallengeListItem: View {
    var challenge: Challenge
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        NavigationLink(destination: ChallengeDetailScreen(challenge: challenge)) {
            HStack {
                Image(systemName: challenge.icon)
                    .fontWeight(.bold)
                    .foregroundStyle(currentSchema.font)
                    .padding(12)
                Text(challenge.name)
                    .fontWeight(.bold)
                    .foregroundStyle(currentSchema.font)
                Spacer()
            }
            .padding(8)
            .background(currentSchema.bar)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .listRowBackground(Color(.secondarySystemBackground))
        .padding(24)
    }
}

struct AddButton: View {
    @Binding var showPopover: Bool
    
    @EnvironmentObject private var colorManagerVM: ColorManagerViewModel
    
    var body: some View {
        let currentSchema = colorManagerVM.colorManager.currentSchema
        
        Button(action: {
            showPopover = true
        }) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(currentSchema.barIcons)
                .padding()
                .frame(width: 220, height: 50)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [6]))
                        .foregroundColor(currentSchema.barIcons)
                )
        }
        .background(.clear)
        .cornerRadius(16)
    }
}


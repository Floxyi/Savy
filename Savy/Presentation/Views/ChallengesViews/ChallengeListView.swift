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
                    ChallengeListItemView(challenge: challenge)
                }
                .onDelete(perform: deleteItems)
                ChallengeAddButtonView(showPopover: $showPopover)
            }
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

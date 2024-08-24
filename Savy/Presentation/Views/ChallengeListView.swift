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
    @State private var name = ""
    @State private var date = Date()
    @State private var notifications = false

    var body: some View {
        VStack(alignment: .center) {
            List {
                ForEach(challenges) { challenge in
                    NavigationLink {
                        ChallengeDetailScreen(challenge: challenge)
                    } label: {
                        Text("Challenge: \(challenge.name)")
                    }
                }
                .onDelete(perform: deleteItems)
            }
            
            Button(action: {
                showPopover = true
            }) {
                Image(systemName: "plus").font(.title)
            }
            .padding(.bottom, 12)
        }
        .popover(isPresented: $showPopover) {
            ChallengeAddView(
                name: $name,
                date: $date,
                notifications: $notifications,
                showPopover: $showPopover
            )
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

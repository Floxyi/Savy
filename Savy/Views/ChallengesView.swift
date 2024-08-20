//
//  ChallengesView.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftUI
import SwiftData

struct ChallengesView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var challenges: [Challenge]

    @State private var showPopover = false
    @State private var challengeName = ""

    var body: some View {
        TabView {
            NavigationView {
                VStack(alignment: .center) {
                    HStack {
                        Text("Challenges")
                            .font(.largeTitle.bold())

                        Spacer()

                        Button(action: {
                            showPopover = true
                        }) {
                            Image(systemName: "plus").font(.title)
                        }
                        .popover(isPresented: $showPopover) {
                            NavigationStack {
                                VStack {
                                    TextField("Challenge Name", text: $challengeName)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .padding()

                                    Spacer()
                                }
                                .padding()
                                .navigationTitle("New Challenge")
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .navigationBarTrailing) {
                                        Button("Done") {
                                            addItem()
                                            showPopover = false
                                        }
                                        .font(.headline)
                                    }
                                }
                            }
                        }
                    }

                    List {
                        ForEach(challenges) { challenge in
                            NavigationLink {
                                Text("Challenge \(challenge.name)")
                            } label: {
                                Text("Challenge \(challenge.name)")
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
                .padding(16)
            }
            .tabItem {
                Label("Challenges", systemImage: "list.bullet")
            }

            LeaderboardView()
                .tabItem {
                    Label("Leaderboard", systemImage: "trophy")
                }

            ProfileView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
        }
    }

    private func addItem() {
        withAnimation {
            let challenge = Challenge(name: challengeName.isEmpty ? Date().formatted() : challengeName)
            modelContext.insert(challenge)
            challengeName = ""
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(challenges[index])
            }
        }
    }
}

#Preview {
    ChallengesView()
        .modelContainer(for: Challenge.self, inMemory: true)
}

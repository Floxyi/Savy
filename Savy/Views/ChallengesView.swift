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
    @State private var date = Date()
    @State private var sendNotifications = false

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
                                    Text("New Challenge")
                                        .font(.system(size: 28).bold())
                                    Form {
                                        TextField(text: $challengeName, prompt: Text("Challenge Name")) {
                                            Text("Challenge Name")
                                        }
                                        DatePicker(
                                            "End Date",
                                            selection: $date,
                                            displayedComponents: [.date]
                                        )
                                        Toggle("Send notifications", isOn: $sendNotifications)
                                    }

                                    Spacer()
                                }
                                .padding()
                                .background(Color(.systemGroupedBackground))
                                .navigationBarTitleDisplayMode(.inline)
                                .toolbar {
                                    ToolbarItem(placement: .confirmationAction) {
                                        Button(action: {
                                            addItem()
                                            showPopover = false
                                        }) {
                                            Text("Done")
                                                .foregroundColor(challengeName.isEmpty ? .gray : .blue)
                                        }
                                        .disabled(challengeName.isEmpty)
                                        .padding()
                                    }
                                    ToolbarItem(placement: .cancellationAction) {
                                        Button("Cancel") {
                                            showPopover = false
                                        }
                                        .font(.system(size: 16))
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
                Label("Challenges", systemImage: "calendar")
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

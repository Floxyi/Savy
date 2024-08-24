//
//  ChallengeAddView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI
import SwiftData

struct ChallengeAddView: View {
    @Environment(\.modelContext) private var modelContext

    @Binding var name: String
    @Binding var date: Date
    @Binding var notifications: Bool
    @Binding var showPopover: Bool

    var body: some View {
        NavigationStack {
            VStack {
                Text("New Challenge")
                    .font(.system(size: 28).bold())
                Form {
                    TextField(text: $name, prompt: Text("Challenge Name")) {
                        Text("Challenge Name")
                    }
                    DatePicker(
                        "End Date",
                        selection: $date,
                        displayedComponents: [.date]
                    )
                    Toggle("Send notifications", isOn: $notifications)
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
                            .foregroundColor(name.isEmpty ? .gray : .blue)
                    }
                    .disabled(name.isEmpty)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        cancelCreation()
                        showPopover = false
                    }
                    .font(.system(size: 16))
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            modelContext.insert(Challenge(name: name, date: date, notifications: notifications))
            do {
                try modelContext.save()
            } catch {
                print(error.localizedDescription)
            }
            cancelCreation()
        }
    }

    private func cancelCreation() {
        name = ""
        date = Date()
        notifications = false
    }
}

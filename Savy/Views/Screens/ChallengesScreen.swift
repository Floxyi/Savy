//
//  ChallengesScreen.swift
//  Savy
//
//  Created by Florian Winkler on 20.08.24.
//

import SwiftData
import SwiftUI

struct ChallengesScreen: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        NavigationView {
            VStack {
                HeaderView(title: String(localized: "Challenges"))
                ChallengesListView()
                HStack {
                    Spacer()
                }
            }
            .padding(.top)
            .padding(.bottom, 112)
            .background(colorServiceVM.colorService.currentScheme.background)
        }
    }
}

#Preview {
    let modelContext = ModelContext(try! ModelContainer(for: ColorService.self))

    return ChallengesScreen()
        .modelContainer(for: [Challenge.self, ColorService.self])
        .environmentObject(ColorServiceViewModel(modelContext: modelContext))
}

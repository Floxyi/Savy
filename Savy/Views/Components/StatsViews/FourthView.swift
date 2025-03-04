//
//  FourthView.swift
//  Savy
//
//  Created by Nadine Schatz on 25.02.25.
//

import SwiftData
import SwiftUI

struct FourthView: View {
    var body: some View {
        Text("Fourth View")
            .font(.largeTitle)
    }
}

#Preview {
    let schema = Schema([ColorService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)

    return StatsScreen()
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
}

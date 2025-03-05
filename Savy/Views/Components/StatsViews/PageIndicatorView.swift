//
//  PageIndicatorView.swift
//  Savy
//
//  Created by Nadine Schatz on 25.02.25.
//

import SwiftData
import SwiftUI

struct PageIndicatorView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var numberOfPages: Int
    var currentPage: Int

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack(spacing: 8) {
            ForEach(0 ..< numberOfPages, id: \.self) { index in
                Circle()
                    .fill(index == currentPage ? currentScheme.font : currentScheme.barIcons)
                    .frame(width: index == currentPage ? 12 : 8, height: index == currentPage ? 12 : 8)
                    .animation(.default, value: currentPage)
            }
        }
    }
}

#Preview {
    let schema = Schema([ColorService.self])
    let container = try! ModelContainer(for: schema, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
    let context = container.mainContext

    let colorServiceViewModel = ColorServiceViewModel(modelContext: context)

    return PageIndicatorView(numberOfPages: 3, currentPage: 1)
        .modelContainer(container)
        .environmentObject(colorServiceViewModel)
}

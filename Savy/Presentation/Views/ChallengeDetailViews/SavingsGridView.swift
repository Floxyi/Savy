//
//  SavingsGridView.swift
//  Savy
//
//  Created by Florian Winkler on 21.10.24.

import SwiftUI

struct SavingsGridView: View {
    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    let savings: [Saving]
    let columns: [GridItem]

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme
        let sortedSavings = savings.filter {
            !$0.done
        }
        .sorted(by: { $0.date < $1.date })

        LazyVGrid(columns: columns, spacing: 16) {
            ForEach(sortedSavings.prefix(15), id: \.id) { saving in
                SavingItemView(saving: saving)
            }
            if sortedSavings.count - 15 > 1 {
                VStack {
                    Text("\(sortedSavings.count - 15)")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundStyle(currentScheme.barIcons)
                    Text("more")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(currentScheme.barIcons)
                }
                .frame(width: 80, height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(style: StrokeStyle(lineWidth: 3, dash: [5]))
                        .foregroundColor(currentScheme.barIcons)
                )
            } else if sortedSavings.count - 15 == 1 {
                SavingItemView(saving: sortedSavings.last!)
            }
        }
    }
}

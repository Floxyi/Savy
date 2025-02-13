//
//  StatsTypeSelector.swift
//  Savy
//
//  Created by Nadine Schatz on 14.10.24.
//

import SwiftUI

struct StatsTypeSelector: View {
    @Binding var selectedStatsType: StatsType

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        Menu {
            ForEach(StatsType.allCases.prefix(1), id: \.self) { statsType in
                Button(action: {
                    selectedStatsType = statsType
                }) {
                    Text(statsType.localizedString)
                }
            }
        } label: {
            HStack {
                Text(selectedStatsType.localizedString)
                    .font(.system(size: 16))
                    .foregroundColor(currentScheme.font)
                Image(systemName: "chevron.down")
                    .font(.system(size: 16))
                    .foregroundColor(currentScheme.font)
            }
            .padding(.horizontal, 8)
            .background(currentScheme.bar)
        }
    }
}

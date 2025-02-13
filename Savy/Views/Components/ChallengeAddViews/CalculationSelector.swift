//
//  CalculationSelector.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct CalculationSelector: View {
    @Binding var selectedCalculation: SavingCalculation

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    public var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack(spacing: 0) {
            Button(action: {
                selectedCalculation = .Date
            }) {
                Text(SavingCalculation.Date.localizedString)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(selectedCalculation == .Date ? currentScheme.font : currentScheme.font.opacity(0.4))
                    .frame(width: 146)
                    .padding(6)
                    .background(selectedCalculation == .Date ? currentScheme.accent1 : .clear)
                    .clipShape(Capsule())
                    .frame(maxWidth: .infinity)
            }

            Button(action: {
                selectedCalculation = .Amount
            }) {
                Text(SavingCalculation.Amount.localizedString)
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(selectedCalculation == .Amount ? currentScheme.font : currentScheme.font.opacity(0.4))
                    .frame(width: 146)
                    .padding(6)
                    .background(selectedCalculation == .Amount ? currentScheme.accent1 : .clear)
                    .clipShape(Capsule())
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: 42)
        .background(currentScheme.bar)
        .cornerRadius(20)
        .padding(.horizontal, 16)
        .padding(.top, 38)
    }
}

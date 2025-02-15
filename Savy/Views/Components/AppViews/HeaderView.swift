//
//  HeaderView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftData
import SwiftUI

struct HeaderView: View {
    var title: String
    var fontSize: CGFloat = 34
    var iconSize: CGFloat = 24
    var dismiss: (() -> Void)? = nil
    var actionView: AnyView? = nil

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        HStack(alignment: .center) {
            if let dismiss {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.backward")
                        .font(.system(size: iconSize, weight: .bold))
                        .foregroundColor(currentScheme.font)
                }
            }

            Spacer()
            Text(title)
                .font(.custom("Shrikhand-Regular", size: fontSize))
                .foregroundStyle(currentScheme.font)
                .lineLimit(1)
                .minimumScaleFactor(0.1)
                .padding(.horizontal, 10)
            Spacer()

            if let actionView {
                actionView
            }
        }
        .padding(.horizontal, 10)
    }
}

#Preview {
    VStack {
        Spacer()
        HeaderView(title: "Challenge")
        Spacer()
        HeaderView(title: "Challenge", dismiss: {})
        Spacer()
        HeaderView(title: "Challenge", dismiss: {}, actionView: AnyView(
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 24, weight: .bold))
                .foregroundColor(.gray)
        ))
        Spacer()
    }
    .environmentObject(ColorServiceViewModel(modelContext: ModelContext(try! ModelContainer(for: ColorService.self))))
}

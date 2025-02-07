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
    var size: CGFloat = 44
    var dismiss: (() -> Void)? = nil
    var actionView: AnyView? = nil

    @EnvironmentObject private var colorServiceVM: ColorServiceViewModel

    var body: some View {
        let currentScheme = colorServiceVM.colorService.currentScheme

        ZStack {
            HStack {
                Text(title)
                    .fontWeight(.bold)
                    .font(.custom("Shrikhand-Regular", size: size))
                    .foregroundStyle(currentScheme.font)
            }

            if let dismiss {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(currentScheme.font)
                    }
                    .padding(.leading, 16)
                    .padding(.bottom, 4)
                    Spacer()
                }
            }

            if let actionView {
                HStack {
                    Spacer()
                    actionView
                        .padding(.trailing, 16)
                        .padding(.bottom, 4)
                }
            }
        }
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

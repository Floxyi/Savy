//
//  DismissableStatsOverlay.swift
//  Savy
//
//  Created by Florian Winkler on 26.09.24.
//

import SwiftUI

struct DismissableStatsOverlay: View {
    var bindings: [Binding<Bool>]

    public var body: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
            }
        }
        .background(Color.black.opacity(0.01))
        .onTapGesture {
            for binding in bindings {
                binding.wrappedValue = false
            }
        }
    }
}

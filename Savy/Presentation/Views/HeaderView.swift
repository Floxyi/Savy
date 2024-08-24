//
//  HeaderView.swift
//  Savy
//
//  Created by Florian Winkler on 22.08.24.
//

import SwiftUI

struct HeaderView: View {
    var title: String

    var body: some View {
        HStack {
            Text(title)
                .font(.largeTitle.bold())
        }
    }
}

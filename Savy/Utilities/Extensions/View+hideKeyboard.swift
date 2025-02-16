//
//  View+hideKeyboard.swift
//  Savy
//
//  Created by Florian Winkler on 16.02.25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

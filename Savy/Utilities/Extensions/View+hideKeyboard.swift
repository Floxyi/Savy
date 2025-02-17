//
//  View+hideKeyboard.swift
//  Savy
//
//  Created by Florian Winkler on 16.02.25.
//

import SwiftUI

/// An extension to the `View` struct that provides a method to hide the keyboard.
extension View {
    /// Hides the keyboard by resigning the first responder status of the currently active text field.
    ///
    /// This method sends an action to the `UIApplication` to dismiss the keyboard for any active text input field in the view.
    ///
    /// - Note: This function works by invoking the `resignFirstResponder` action on the first responder (active text input field) to dismiss the keyboard.
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

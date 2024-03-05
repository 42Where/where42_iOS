//
//  HideKeyboard.swift
//  Where42
//
//  Created by 현동호 on 2/29/24.
//

import SwiftUI

extension View {
    func hideKeyboardOnTap() -> some View {
        return self.onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

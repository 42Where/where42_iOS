//
//  HideKeyboard.swift
//  Where42
//
//  Created by 현동호 on 2/29/24.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

//
//  LoginViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI

extension LoginView {
    class LoginViewModel: ObservableObject {
        @Published var isHelpPagePresent: Bool = false
    }
}

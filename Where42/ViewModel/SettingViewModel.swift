//
//  SettingViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/10/23.
//

import SwiftUI

extension SettingView {
    class SettingViewModel: ObservableObject {
        @Published var isLogoutAlertPresent = false
        @Published var isStatusMessageAlertPresent = false
        @Published var statusMessage = ""
    }
}

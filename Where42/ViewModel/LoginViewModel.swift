//
//  LoginViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var isHelpPagePresented = false
    @Published var isShowAgreementSheet = false
    @Published var isLoginButtonPushed = false
    @Published var isAgreeButtonPushed = false

    let memberAPI = MemberAPI.shared
    let loginAPI = LoginAPI.shared

    func login() {
        Task {
            do {
                let response = try await memberAPI.getMemberInfo()
                if response == nil {
                    DispatchQueue.main.async {
                        MainViewModel.shared.is42IntraSheetPresented = true
                        self.isLoginButtonPushed = false
                    }
                }
            } catch {
                print("Error login: \(error)")
            }
        }
    }

    func join(intraId: String) {
        Task {
            await loginAPI.join(intraId: intraId)
            self.isAgreeButtonPushed = false
        }
    }
}

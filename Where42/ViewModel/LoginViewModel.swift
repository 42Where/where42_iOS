//
//  LoginViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var isHelpPagePresent = false
    @Published var isShow42IntraSheet = false
    @Published var isLoginButtonPushed = false
    @Published var isAgreeButtonPushed = false
    @Published var intraURL: String? = ""

    let memberAPI = MemberAPI.shared
    let loginAPI = LoginAPI.shared

    func login() {
        Task {
            do {
                let response = try await memberAPI.getMemberInfo(intraId: 99760)
                if response == nil {
                    DispatchQueue.main.async {
                        self.intraURL = "http://13.209.149.15:8080/v3/member?intraId=99760"
                        self.isShow42IntraSheet = true
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

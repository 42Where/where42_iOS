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

    let memberAPI = MemberAPI()
    let loginAPI = LoginAPI()

    func login() {
        Task {
            do {
                let (_, url) = try await memberAPI.getMemberInfo(intraId: 99760)
                if url != nil {
                    DispatchQueue.main.async {
                        self.intraURL = url
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

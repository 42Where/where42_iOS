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
    @Published var dots = ""

    var timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

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
                        self.dots = ""
                        self.timer.upstream.connect().cancel()
                    }
                }
            } catch {
                print("Error login: \(error)")
            }
        }
    }

    func join(intraId: String) async -> Bool {
        do {
            try await loginAPI.join(intraId: intraId)
            DispatchQueue.main.async {
                self.isAgreeButtonPushed = false
            }
            return true
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                self.isAgreeButtonPushed = false
            }
            MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
        } catch {}
        return false
    }
}

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
                try await loginAPI.login()
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    MainViewModel.shared.is42IntraSheetPresented = true
                    self.isLoginButtonPushed = false
                    self.dots = ""
                    self.timer.upstream.connect().cancel()
                }
            } catch {
                ErrorHandler.errorPrint(error, message: "Failed to Login")
            }
        }
    }

    func join(intraId: String) async -> Bool {
        do {
            try await loginAPI.join(intraId: intraId)
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isAgreeButtonPushed = false
            }
            return true
        } catch NetworkError.Reissue {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.isAgreeButtonPushed = false
            }
            MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to join")
        }
        return false
    }
}

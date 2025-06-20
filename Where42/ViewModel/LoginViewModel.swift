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
        Task { [weak self] in
            guard let self = self else { return }
            do {
                try await loginAPI.login()
                await initLoginField()
            } catch {
                ErrorHandler.errorPrint(error, message: "Failed to Login")
            }
        }
    }
    
    @MainActor
    private func initLoginField() {
        MainViewModel.shared.is42IntraSheetPresented = true
        self.isLoginButtonPushed = false
        self.dots = ""
        self.timer.upstream.connect().cancel()
    }

    func join(intraId: String) async -> Bool {
        do {
            try await loginAPI.join(intraId: intraId)
            await disableAgreeButtonPushed()
            return true
        } catch NetworkError.Reissue {
            await disableAgreeButtonPushed()
            await setToast()
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to join")
        }
        return false
    }
    
    @MainActor
    private func disableAgreeButtonPushed() {
        self.isAgreeButtonPushed = false
    }
    
    @MainActor
    private func setToast() {
        MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
    }
}

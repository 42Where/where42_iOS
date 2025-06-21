//
//  MainViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/9/23.
//

import SwiftUI

extension UIDevice {
    static var idiom: UIUserInterfaceIdiom {
        UIDevice.current.userInterfaceIdiom
    }
}

class MainViewModel: ObservableObject {
    static let shared = MainViewModel()

    @AppStorage("isLogin") var isLogin = false

    @Published var tabSelection: String = "Home"

    @Published var isSelectViewPrsented = false
    @Published var isPersonalViewPrsented = false
    @Published var isNewGroupAlertPrsented = false
    @Published var isEditGroupNameAlertPrsented = false
    @Published var isDeleteGroupAlertPrsented = false
    @Published var isUpdateNeeded = false

    let intraURL: String = Bundle.main.object(forInfoDictionaryKey: "BaseURL") as? String ?? "https://api.where42.kr/v3/member"
    @Published var is42IntraSheetPresented = false

    @Published var toast: Toast? = nil

    private let loginAPI = LoginAPI.shared
    private let versionAPI = VersionAPI()
    
    func setToast(type: String?) {
        DispatchQueue.main.async { [weak self] in

            guard let self = self else { return }

            switch type {
            case "wrongGroupName":
                self.toast = Toast(title: "잘못된 그룹 이름입니다")
            case "longGroupName":
                self.toast = Toast(title: "그룹 이름이 너무 깁니다")
            case "duplicateGroupName":
                self.toast = Toast(title: "이미 존재하는 그룹 이름입니다")
            case "wrongComment":
                self.toast = Toast(title: "잘못된 코멘트입니다")
            case "longComment":
                self.toast = Toast(title: "코멘트가 너무 깁니다, 40자 이하로 입력해주세요")
            case "reissue":
                self.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            default:
                return
            }
        }
    }

    func checkVersion() async {
        do {
            try await versionAPI.checkUpdateNeeded()
            await setUpdateNeeded(false)
        } catch NetworkError.VersionUpdate {
            await setUpdateNeeded(true)
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to check if version update needed")
        }
    }
    
    @MainActor
    private func setUpdateNeeded(_ isNeeded: Bool) {
        self.isUpdateNeeded = isNeeded
    }
    
    func logout() async {
        do {
            try await loginAPI.logout()
            if let _ = KeychainManager.readToken(key: "accessToken") {
                KeychainManager.deleteToken(key: "accessToken")
            }
            if let _ = KeychainManager.readToken(key: "intraId") {
                KeychainManager.deleteToken(key: "intraId")
            }
            self.isLogin = false
        } catch {
            ErrorHandler.errorPrint(error, message: "Failed to logout")
        }
    }
}

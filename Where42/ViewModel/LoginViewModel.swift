//
//  LoginViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var isHelpPagePresent: Bool = false

    let memberAPI = MemberAPI()
    let loginAPI = LoginAPI()

    func login(isPresent: Binding<Bool>) async {
//            do {
//                let (member, url) = try await memberAPI.getMemberInfo(intraId: 6)
//                if url != nil {}
//            } catch {
//                print("Failed to Login")
//            }
    }

    func join(intraId: String) {
        Task {
            await loginAPI.join(intraId: intraId)
        }
    }
}

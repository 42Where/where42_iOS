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
    @Published var tabSelection: String = "Home"
    @Published var isSelectViewPrsented = false
    @Published var isPersonalViewPrsented = false
    @Published var isNewGroupAlertPrsented = false
    @Published var isEditGroupNameAlertPrsented = false
    @Published var isDeleteGroupAlertPrsented = false
    @Published var newGroupName = "수정중..."
    @Published var toast: Toast? = nil

    func setToast(type: String?) {
        switch type {
        case "wrongGroupName":
            toast = Toast(title: "잘못된 그룹 이름 형식입니다")
        case "longGroupName":
            toast = Toast(title: "그룹 이름이 너무 깁니다")
        case "duplicateGroupName":
            toast = Toast(title: "이미 존재하는 그룹 이름입니다")
        case "wrongComment":
            toast = Toast(title: "잘못된 코멘트 형식입니다")
        case "longComment":
            toast = Toast(title: "코멘트가 너무 깁니다")
        default:
            return
        }
    }
}

//
//  MainViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/9/23.
//

import SwiftUI

class MainViewModel: ObservableObject {
    @Published var tabSelection: String = "Home"
    @Published var isSelectViewPrsented = false
    @Published var isPersonalViewPrsented = false
    @Published var isNewGroupAlertPrsented = false
    @Published var isEditGroupNameAlertPrsented = false
    @Published var isDeleteGroupAlertPrsented = false
    @Published var newGroupName = "수정중..."
}

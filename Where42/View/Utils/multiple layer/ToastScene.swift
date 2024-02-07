//
//  ToastScene.swift
//  Where42
//
//  Created by 현동호 on 2/7/24.
//

import SwiftUI

struct ToastScene: View {
    @EnvironmentObject private var mainViewModel: MainViewModel

    var body: some View {
        Color.clear
            .toastView(toast: $mainViewModel.toast, shadow: false)
    }
}

#Preview {
    ToastScene()
}

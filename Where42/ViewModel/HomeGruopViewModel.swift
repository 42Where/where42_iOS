//
//  HomeGruopViewModel.swift
//  Where42
//
//  Created by 현동호 on 11/10/23.
//

import SwiftUI

extension HomeGroupView {
    class HomeGruopViewModel: ObservableObject {
        @Published var modalHeight: CGFloat = 0
        @Published var isEditModalSheetPresent: Bool = false
    }
}

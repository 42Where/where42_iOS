//
//  groupBar.swift
//  Where42
//
//  Created by 현동호 on 1/8/24.
//

import SwiftUI

struct HomeGroupSingleView: View {
    var body: some View {
        VStack {}
    }
}

#Preview {
    HomeGroupSingleView(group: .constant(.empty))
        .environmentObject(HomeViewModel())
        .environmentObject(HomeGroupViewModel())
}

//
//  StatView.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import SwiftUI

struct StatView: View {

    @EnvironmentObject private var homeViewModel: HomeViewModel
    @StateObject var statViewModel: StatViewModel = .init()

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    Text("클러스터 실시간 현황")
                    Spacer()
                }
                ClusterUsageView()
                IMacUsageView()
                UserSeatHistoryView()
                PopularImacView()
            }
        }
        .padding(EdgeInsets(top: 40, leading: 40, bottom: 40, trailing: 40))
    }
}

#Preview {
    StatView()
}

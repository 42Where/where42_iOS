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
    private var intraName: String {
        let name = homeViewModel.myInfo.intraName
        return name == "nil" ? "" : name
    }
    
    var body: some View {
        if 1 == 1 {
            ScrollView {
                LazyVStack(spacing: 20) {
                    Section {
                        ClusterUsageView()
                            .environmentObject(statViewModel)
                        IMacUsageView()
                            .environmentObject(statViewModel)
                    } header: {
                        HStack {
                            Text("클러스터 실시간 현황")
                                .font(.GmarketBold18)
                            Spacer()
                        }
                    }

                    Section {
                        UserSeatHistoryView()
                            .environmentObject(statViewModel)
                    } header: {
                        HStack {
                            Text("\(intraName)님의 정보")
                                .font(.GmarketBold18)
                            Spacer()
                        }
                    }
                    
                    Section {
                        PopularImacView()
                            .environmentObject(statViewModel)
                    } header: {
                        HStack {
                            Text("42Seoul 인기자리")
                                .font(.GmarketBold18)
                            Spacer()
                        }
                    }
                }
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            .onAppear {
                statViewModel.isLoaded = true
                statViewModel.clusterUsages[0].usageRate = 1
                statViewModel.clusterUsages[0].totalImacCount = 63
                statViewModel.clusterUsages[0].usingImacCount = 6
                statViewModel.clusterUsages[1].usageRate = 30
                statViewModel.clusterUsages[1].totalImacCount = 80
                statViewModel.clusterUsages[1].usingImacCount = 24
                statViewModel.clusterUsages[2].usageRate = 30
                statViewModel.clusterUsages[2].totalImacCount = 63
                statViewModel.clusterUsages[2].usingImacCount = 19
                statViewModel.clusterUsages[3].usageRate = 30
                statViewModel.clusterUsages[3].totalImacCount = 80
                statViewModel.clusterUsages[3].usingImacCount = 24
                statViewModel.clusterUsages[4].usageRate = 30
                statViewModel.clusterUsages[4].totalImacCount = 28
                statViewModel.clusterUsages[4].usingImacCount = 8
                statViewModel.clusterUsages[5].usageRate = 30
                statViewModel.clusterUsages[5].totalImacCount = 56
                statViewModel.clusterUsages[5].usingImacCount = 17
                statViewModel.iMacUsage.totalUserCount = 230
                statViewModel.iMacUsage.usingImacUserCount = 228
                statViewModel.userSeatHistory.append(SingleUserSeatHistory(seat: "c2r6s1", usingTimeHour: 9, usingTimeMinute: 9, usingTimeSecond: 9, usingCount: 9))
                statViewModel.popularIMacs.append(SinglePopularIMac(seat: "c1r1s1", usingTimeHour: 0, usingTimeMinute: 0, usingTimeSecond: 0, usingCount: 0))
                statViewModel.popularIMacs.append(SinglePopularIMac(seat: "c2r2s2", usingTimeHour: 0, usingTimeMinute: 0, usingTimeSecond: 0, usingCount: 0))
                statViewModel.popularIMacs.append(SinglePopularIMac(seat: "c3r3s3", usingTimeHour: 0, usingTimeMinute: 0, usingTimeSecond: 0, usingCount: 0))
                statViewModel.popularIMacs.append(SinglePopularIMac(seat: "c4r4s4", usingTimeHour: 0, usingTimeMinute: 0, usingTimeSecond: 0, usingCount: 0))
                statViewModel.popularIMacs.append(SinglePopularIMac(seat: "c5r5s5", usingTimeHour: 0, usingTimeMinute: 0, usingTimeSecond: 0, usingCount: 0))
            }
        } else {
            ProgressView()
        }
    }
}

#Preview {
    StatView()
        .environmentObject(HomeViewModel())
}

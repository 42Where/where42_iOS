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
        ScrollView {
            LazyVStack(spacing: 20) {
                if statViewModel.isLoaded {
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
                } else {
                    ProgressView()
                }
            }
            .padding(EdgeInsets(top: 40, leading: 20, bottom: 40, trailing: 20))
            .task {
                if !statViewModel.isLoaded {
                    await statViewModel.fetchData()
                    statViewModel.setClusterUsages()
                }
            }
        }
        .refreshable {
            Task {
                await statViewModel.fetchData()
                statViewModel.makeDefaultClusterUsages()
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                statViewModel.setClusterUsages()
            }
        }
    }
}

#Preview {
    StatView()
        .environmentObject(HomeViewModel())
}

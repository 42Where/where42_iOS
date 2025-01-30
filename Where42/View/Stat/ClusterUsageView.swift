//
//  ClusterUsageView.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import SwiftUI

struct ClusterUsageView: View {
    
    @EnvironmentObject var statViewModel: StatViewModel
    
    var body: some View {
        LazyVStack(spacing: 40) {
            Text("클러스터 별 이용률")
                .font(.GmarketMedium18)
            if statViewModel.clusterUsages.count != 8 {
                Text("정상적인 데이터를 수신하지 못했습니다")
                    .font(.GmarketLight18)
            } else {
                HStack {
                    SingleClusterUsageView(curIdx: 0)
                        .environmentObject(statViewModel)
                    Spacer()
                    SingleClusterUsageView(curIdx: 1)
                        .environmentObject(statViewModel)
                }
                HStack {
                    SingleClusterUsageView(curIdx: 6)
                        .environmentObject(statViewModel)
                    Spacer()
                    SingleClusterUsageView(curIdx: 7)
                        .environmentObject(statViewModel)
                }
                HStack {
                    SingleClusterUsageView(curIdx: 2)
                        .environmentObject(statViewModel)
                    Spacer()
                    SingleClusterUsageView(curIdx: 3)
                        .environmentObject(statViewModel)
                }
                //            HStack {
                //                VStack {
                //                    Circle()
                //                        .frame(width: 20)
                //                        .foregroundStyle(.whereLightNavy)
                //                    Text("수용 인원")
                //                }
                //                Divider()
                //                VStack {
                //                    Circle()
                //                        .frame(width: 20)
                //                        .foregroundStyle(.whereDeepNavy)
                //                    Text("출석 인원")
                //                }
                //            }
            }
        }
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.black, lineWidth: 1.0)
        )
    }
}

#Preview {
    ClusterUsageView()
        .environmentObject(StatViewModel())
}

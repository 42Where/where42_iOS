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
            HStack {
                SingleClusterUsageView(clusterName: Cluster.c1.rawValue)
                    .environmentObject(statViewModel)
                Spacer()
                SingleClusterUsageView(clusterName: Cluster.c2.rawValue)
                    .environmentObject(statViewModel)
            }
            HStack {
                SingleClusterUsageView(clusterName: Cluster.c5.rawValue)
                    .environmentObject(statViewModel)
                Spacer()
                SingleClusterUsageView(clusterName: Cluster.c6.rawValue)
                    .environmentObject(statViewModel)
            }
            HStack {
                SingleClusterUsageView(clusterName: Cluster.cx1.rawValue)
                    .environmentObject(statViewModel)
                Spacer()
                SingleClusterUsageView(clusterName: Cluster.cx2.rawValue)
                    .environmentObject(statViewModel)
            }
            HStack {
                VStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(.whereLightNavy)
                    Text("사용 가능 자리")
                        .font(.GmarketLight14)
                }
                Divider()
                VStack {
                    Circle()
                        .frame(width: 10)
                        .foregroundStyle(.whereDeepNavy)
                    Text("사용 중인 자리")
                        .font(.GmarketLight14)
                }
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

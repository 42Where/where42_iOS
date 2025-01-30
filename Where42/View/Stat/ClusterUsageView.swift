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
                SingleClusterUsageView(curIdx: 0)
                    .environmentObject(statViewModel)
                Spacer()
                SingleClusterUsageView(curIdx: 1)
                    .environmentObject(statViewModel)
            }
            HStack {
                SingleClusterUsageView(curIdx: 2)
                    .environmentObject(statViewModel)
                Spacer()
                SingleClusterUsageView(curIdx: 3)
                    .environmentObject(statViewModel)
            }
            HStack {
                SingleClusterUsageView(curIdx: 4)
                    .environmentObject(statViewModel)
                Spacer()
                SingleClusterUsageView(curIdx: 5)
                    .environmentObject(statViewModel)
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

//
//  SingleClusterUsageView.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import SwiftUI

struct SingleClusterUsageView: View {
    
    @EnvironmentObject var statViewModel: StatViewModel
    @State var clusterName: String = ""
    
    var body: some View {
        VStack(spacing: 2) {
            ZStack {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 60))
                    .frame(width: 60, height: 60)
                    .foregroundStyle(.whereLightNavy)
                Circle()
                    .trim(from: 0.0, to: CGFloat(statViewModel.clusterUsagesDic[clusterName]?.usageRate ?? 0) / 100.0)
                    .stroke(style: StrokeStyle(lineWidth: 60, lineCap: .butt, lineJoin: .round))
                    .frame(width: 60, height: 60)
                    .foregroundColor(.whereDeepNavy)
                    .rotationEffect(.degrees(-90))
                    .animation(.easeInOut(duration: 1), value: Double(statViewModel.clusterUsagesDic[clusterName]?.usageRate ?? 0) / 100.0)
            }
            
            Rectangle()
                .frame(width: 30, height: 30)
                .foregroundColor(.clear)
                .background(.clear)
            
            Text(getClusterNameString())
                .font(.GmarketMedium14)
                .foregroundStyle(.black)
            Text(getUsageRateText())
                .font(.GmarketMedium14)
                .foregroundStyle(.black)
        }
        .frame(width: 120, height: 120)
    }
    
    private func getClusterNameString() -> String {
        return clusterName.uppercased()
    }
    
    private func getUsageRateText() -> String {
        let usingImacCount = statViewModel.clusterUsagesDic[clusterName]?.usingImacCount ?? 0
        let totalImacCount = statViewModel.clusterUsagesDic[clusterName]?.totalImacCount ?? 0
        return "(\(usingImacCount) / \(totalImacCount))"
    }
}

#Preview {
    SingleClusterUsageView()
        .environmentObject(StatViewModel())
}

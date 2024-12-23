//
//  ClustersView.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI

struct ClustersView: View {
    @ObservedObject private var clustersViewModel = ClustersViewModel()
    
    var body: some View {
        VStack {
            Picker("클러스터", selection: $clustersViewModel.selectedCluster) {
                ForEach(Cluster.allCases, id: \.self) { cluster in
                    Text(cluster.rawValue.uppercased())
                }
            }
            .pickerStyle(.menu)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.whereDeepNavy, lineWidth: 2) // 테두리 설정
            )
            .font(.GmarketBold24)
            .foregroundStyle(.whereDeepNavy)
            .cornerRadius(8)
            .tint(.whereDeepNavy)
            
            Spacer()
            
            switch clustersViewModel.selectedCluster {
            case .c1:
                ClusterC1View()
                    .environmentObject(clustersViewModel)
            case .c2:
                ClusterC2View()
                    .environmentObject(clustersViewModel)
            case .c5:
                ClusterC5View()
                    .environmentObject(clustersViewModel)
            case .c6:
                ClusterC6View()
                    .environmentObject(clustersViewModel)
            case .cx1:
                ClusterCX1View()
                    .environmentObject(clustersViewModel)
            case .cx2:
                ClusterCX2View()
                    .environmentObject(clustersViewModel)
            }
            
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 50, bottom: 16, trailing: 50))
    }
}

#Preview {
    ClustersView()
}

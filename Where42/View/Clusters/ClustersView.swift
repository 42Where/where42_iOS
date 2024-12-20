//
//  ClustersView.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI

struct ClustersView: View {
    @State private var selectedCluster: Cluster = .c1
    var body: some View {
        VStack {
            Picker("클러스터", selection: $selectedCluster) {
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
            SelectedClusterView()
            Spacer()
        }
    }
}

#Preview {
    ClustersView()
}

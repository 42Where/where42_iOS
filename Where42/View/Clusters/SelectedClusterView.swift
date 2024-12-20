//
//  SelectedClusterView.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI

struct SelectedClusterView: View {
    // example
    var selectedCluster: Cluster = .c1
    var body: some View {
        switch selectedCluster {
        case .c1:
            ClusterC1View()
        case .c2:
            ClusterC2View()
        case .c5:
            ClusterC5View()
        case .c6:
            ClusterC6View()
        case .cx1:
            ClusterCX1View()
        case .cx2:
            ClusterCX2View()
        }
    }
}

#Preview {
    SelectedClusterView()
}

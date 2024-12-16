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
        case .C2:
            ClusterC2View()
        case .C5:
            ClusterC5View()
        case .C6:
            ClusterC6View()
        case .CX1:
            ClusterCX1View()
        case .CX2:
            ClusterCX2View()
        }
    }
}

#Preview {
    SelectedClusterView()
}

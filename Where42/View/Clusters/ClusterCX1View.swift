//
//  ClusterCX1View.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI
import Kingfisher

struct ClusterCX1View: View {
    @EnvironmentObject var clustersViewModel: ClustersViewModel
    @State var cx1Arr: [[ClusterSeatInfo]] = [[]]
    
    var body: some View {
        VStack {
            if cx1Arr.count == 5 {
            }
        }
        .task {
            cx1Arr = await clustersViewModel.getClusterArr(cluster: .cx1)
        }
    }
}

#Preview {
    ClusterCX1View()
        .environmentObject(ClustersViewModel())
}

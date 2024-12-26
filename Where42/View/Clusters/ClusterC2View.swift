//
//  ClusterC2View.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI
import Kingfisher

struct ClusterC2View: View {
    @EnvironmentObject private var clustersViewModel: ClustersViewModel
    
    var body: some View {
        VStack {
            if clustersViewModel.c2Arr.count == 10 {
                ForEach(0..<10) { row in
                    HStack {
                        Text("r\(10 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(clustersViewModel.c2Arr[9 - row]) { seat in
                            Seat_SeatTextView(seat: seat)
                            .frame(width: 25, height: 40)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            clustersViewModel.c2Arr = await clustersViewModel.getClusterArr(cluster: .c2)
        }
    }
}

#Preview {
    ClusterC2View()
        .environmentObject(ClustersViewModel())
}

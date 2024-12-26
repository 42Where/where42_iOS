//
//  ClusterC5View.swift
//  Where42
//
//  Created by 이창현 on 12/20/24.
//

import SwiftUI
import Kingfisher

struct ClusterC5View: View {
    @EnvironmentObject private var clustersViewModel: ClustersViewModel
    
    var body: some View {
        VStack {
            if clustersViewModel.c5Arr.count == 9 {
                ForEach(0..<9) { row in
                    HStack {
                        Text("r\(9 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(clustersViewModel.c5Arr[8 - row]) { seat in
                            Seat_SeatTextView(seat: seat)
                            .frame(width: 30, height: 40)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            clustersViewModel.c5Arr = await clustersViewModel.getClusterArr(cluster: .c5)
        }
    }
}

#Preview {
    ClusterC5View()
        .environmentObject(ClustersViewModel())
}

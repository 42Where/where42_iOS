//
//  ClusterC6View.swift
//  Where42
//
//  Created by 이창현 on 12/20/24.
//

import SwiftUI
import Kingfisher

struct ClusterC6View: View {
    @EnvironmentObject private var clustersViewModel: ClustersViewModel
    
    var body: some View {
        VStack {
            if clustersViewModel.c6Arr.count == 10 {
                ForEach(0..<10) { row in
                    HStack {
                        Text("r\(10 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(clustersViewModel.c6Arr[9 - row]) { seat in
                            Seat_SeatTextView(seat: seat)
                                .frame(width: 25, height: 40)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            clustersViewModel.c6Arr = await clustersViewModel.getClusterArr(cluster: .c6)
        }
    }
}

#Preview {
    ClusterC6View()
        .environmentObject(ClustersViewModel())
}

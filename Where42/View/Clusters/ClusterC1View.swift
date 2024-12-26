//
//  ClusterC1View.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI
import Kingfisher

struct ClusterC1View: View {
    @EnvironmentObject private var clustersViewModel: ClustersViewModel
    
    var body: some View {
        VStack {
            if clustersViewModel.c1Arr.count == 9 {
                ForEach(0..<9) { row in
                    HStack {
                        Text("r\(9 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(clustersViewModel.c1Arr[8 - row]) { seat in
                            Seat_SeatTextView(seat: seat)
                            .frame(width: 30, height: 40)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            await clustersViewModel.updateClusterArr(cluster: .c1)
        }
    }
}

#Preview {
    ClusterC1View()
        .environmentObject(ClustersViewModel())
}

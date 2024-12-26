//
//  ClusterCX2View.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI
import Kingfisher

struct ClusterCX2View: View {
    @EnvironmentObject var clustersViewModel: ClustersViewModel
    @State var cx2Arr: [[ClusterSeatInfo]] = [[]]
    
    var body: some View {
        VStack {
            if cx2Arr.count == 8 {
                ForEach(0..<8) { row in
                    HStack {
                        Text("r\(8 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 30, alignment: .leading)
                        Spacer()
                        ForEach(cx2Arr[7 - row]) { seat in
                            if seat.isValidSeat() {
                                Seat_SeatTextView(seat: seat)
                                .frame(width: 22, height: 40)
                            } else {
                                Text("")
                                    .frame(width: 22)
                            }
                        }
                    }
                }
            }
        }
        .task {
            cx2Arr = await clustersViewModel.getClusterArr(cluster: .cx2)
        }
    }
}

#Preview {
    ClusterCX2View()
        .environmentObject(ClustersViewModel())
}

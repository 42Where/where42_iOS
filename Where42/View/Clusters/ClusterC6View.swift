//
//  ClusterC6View.swift
//  Where42
//
//  Created by 이창현 on 12/20/24.
//

import SwiftUI
import Kingfisher

struct ClusterC6View: View {
    @EnvironmentObject var clustersViewModel: ClustersViewModel
    @State var c6Arr: [[ClusterSeatInfo]] = [[]]
    
    var body: some View {
        VStack {
            if c6Arr.count == 10 {
                ForEach(0..<10) { row in
                    HStack {
                        Text("r\(10 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(c6Arr[9 - row]) { seat in
                            VStack {
                                if seat.isLoggedIn {
                                    if let url = URL(string: seat.image) {
                                        if !seat.isFriend {
                                            KFImage(url)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                        }
                                        else {
                                            KFImage(url)
                                                .resizable()
                                        }
                                    }
                                } else {
                                    Image("Imac icon")
                                        .resizable()
                                        .frame(width: 10, height: 10)
                                }
                                Text("\(seat.seat)")
                                    .foregroundStyle(.whereDeepNavy)
                                    .font(.GmarketMedium14)
                                    .monospaced()
                            }
                            .frame(width: 25, height: 40)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            c6Arr = await clustersViewModel.getClusterArr(cluster: .c6)
        }
    }
}

#Preview {
    ClusterC6View()
        .environmentObject(ClustersViewModel())
}

//
//  ClusterC2View.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI
import Kingfisher

struct ClusterC2View: View {
    @EnvironmentObject var clustersViewModel: ClustersViewModel
    @State var c2Arr: [[ClusterSeatInfo]] = [[]]
    
    var body: some View {
        VStack {
            if c2Arr.count == 10 {
                ForEach(0..<10) { row in
                    HStack {
                        Text("r\(10 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(c2Arr[9 - row]) { seat in
                            VStack {
                                if seat.isLoggedIn {
                                    if let url = URL(string: seat.image) {
                                        if seat.isFriend {
                                            KFImage(url)
                                                .resizable()
                                                .placeholder {
                                                    Image("Imac icon")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                }
                                                .scaledToFit()
                                                .overlay(Rectangle().stroke(.whereDeepPink, lineWidth: 2))
                                                .frame(width: 24, height: 24)
                                        }
                                        else {
                                            KFImage(url)
                                                .resizable()
                                                .placeholder {
                                                    Image("Imac icon")
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                }
                                                .scaledToFit()
                                                .frame(width: 24, height: 24)
                                        }
                                    }
                                } else {
                                    Image("Imac icon")
                                        .resizable()
                                        .frame(width: 24, height: 24)
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
            c2Arr = await clustersViewModel.getClusterArr(cluster: .c2)
        }
    }
}

#Preview {
    ClusterC2View()
        .environmentObject(ClustersViewModel())
}

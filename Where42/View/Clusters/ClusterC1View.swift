//
//  ClusterC1View.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import SwiftUI
import Kingfisher

struct ClusterC1View: View {
    @EnvironmentObject var clustersViewModel: ClustersViewModel
    @State var c1Arr: [[ClusterSeatInfo]] = [[]]
    
    var body: some View {
        VStack {
            if c1Arr.count == 9 {
                ForEach(0..<9) { row in
                    HStack {
                        Text("r\(9 - row)")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 40, alignment: .leading)
                        Spacer()
                        ForEach(c1Arr[8 - row]) { seat in
                            VStack {
                                if seat.isLoggedIn {
                                    if let url = URL(string: seat.image) {
                                        if seat.isFriend {
                                            KFImage(url)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                                .overlay(Rectangle().stroke(.whereDeepPink, lineWidth: 1))
                                        }
                                        else {
                                            KFImage(url)
                                                .resizable()
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
                            .frame(width: 30, height: 40)
                            Spacer()
                        }
                    }
                }
            }
        }
        .task {
            c1Arr = await clustersViewModel.getClusterArr(cluster: .c1)
        }
    }
}

#Preview {
    ClusterC1View()
        .environmentObject(ClustersViewModel())
}

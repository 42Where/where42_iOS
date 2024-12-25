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
                // r3
                Spacer()
                HStack {
                    Group {
                        Text("r3")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 30, alignment: .leading)
                        Cx1R1R2R3View(seats: cx1Arr[2])
                            .frame(width: 70, height: 140)
                        Text("")
                            .frame(width: 180, height: 140)
                    }
                }
                
                Spacer()
                
                // r2, r5
                HStack {
                    Group {
                        Text("r2")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 30, alignment: .leading)
                        Cx1R1R2R3View(seats: cx1Arr[1])
                            .frame(width: 70, height: 140)
                        Text("")
                            .frame(width: 30)
                        Cx1R4R5View(seats: cx1Arr[4])
                            .frame(width: 120, height: 140)
                        Text("r5")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 30, alignment: .trailing)
                    }
                }
                
                Spacer()
                
                // r1, r4
                HStack {
                    Group {
                        Text("r1")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 30, alignment: .leading)
                        Cx1R1R2R3View(seats: cx1Arr[0])
                            .frame(width: 70, height: 140)
                        Text("")
                            .frame(width: 30)
                        Cx1R4R5View(seats: cx1Arr[3])
                            .frame(width: 120, height: 140)
                        Text("r4")
                            .foregroundStyle(.whereDeepNavy)
                            .font(.GmarketMedium18)
                            .monospaced()
                            .frame(width: 30, alignment: .trailing)
                    }
                }
                Spacer()
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

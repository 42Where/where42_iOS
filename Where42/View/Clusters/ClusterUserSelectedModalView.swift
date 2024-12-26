//
//  ClusterUserSelectedModalView.swift
//  Where42
//
//  Created by ch on 12/26/24.
//

import SwiftUI
import Kingfisher

struct ClusterUserSelectedModalView: View {
    
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var clustersViewModel: ClustersViewModel
    
    var body: some View {
        if let selectedSeat = clustersViewModel.selectedSeat {
            HStack(spacing: 10) {
                KFImage(URL(string: selectedSeat.image)!)
                    .resizable()
                    .placeholder {
                        Image("Profile")
                            .resizable()
                            .frame(width: 80, height: 80)
                    }
                    .clipShape(Circle())
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                
                VStack(alignment: .leading, spacing: 10) {
                    Text(selectedSeat.intraName)
                        .font(.custom(Font.GmarketBold, size: 20))
                        .foregroundStyle(.whereDeepNavy)
                    
                    Text("\(selectedSeat.cluster)r\(selectedSeat.row)s\(selectedSeat.seat)")
                        .font(.custom(Font.GmarketMedium, size: 15))
                        .padding(5.0)
                        .padding(.horizontal, 2.0)
                        .background(.whereDeepNavy)
                        .clipShape(Capsule())
                        .overlay(Capsule().stroke(.whereDeepNavy, lineWidth: 0))
                        .foregroundStyle(.white)
                }
                
                Spacer()
                
                if !selectedSeat.isFriend{
                    Button {
                        Task {
                            if await clustersViewModel.addFriend(clusterSeat: selectedSeat) {
                                await homeViewModel.getGroup()
                                switch selectedSeat.cluster {
                                case "c1":
                                    clustersViewModel.c1Arr = await clustersViewModel.getClusterArr(cluster: .c1)
                                case "c2":
                                    clustersViewModel.c2Arr = await clustersViewModel.getClusterArr(cluster: .c2)
                                case "c5":
                                    clustersViewModel.c5Arr = await clustersViewModel.getClusterArr(cluster: .c5)
                                case "c6":
                                    clustersViewModel.c6Arr = await clustersViewModel.getClusterArr(cluster: .c6)
                                case "cx1":
                                    clustersViewModel.cx1Arr = await clustersViewModel.getClusterArr(cluster: .cx1)
                                case "cx2":
                                    clustersViewModel.cx2Arr = await clustersViewModel.getClusterArr(cluster: .cx2)
                                default:
                                    fatalError("Unrecognized cluster seat tried to add friend")
                                }
                            }
                            clustersViewModel.isModalPresented = false
                        }
                    } label: {
                        Image("Add Friend icon")
                            .resizable()
                            .frame(width: 30, height: 30)
                    }
                    .foregroundStyle(.whereDeepNavy)
                }
                
                
            }
            .padding([.top, .leading, .trailing])
            .onDisappear() {
                clustersViewModel.selectedSeat = nil
            }
        }
    }
}

#Preview {
    ClusterUserSelectedModalView()
}

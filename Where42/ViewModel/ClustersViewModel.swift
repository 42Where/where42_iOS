//
//  ClustersViewModel.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import Foundation

class ClustersViewModel: ObservableObject {
    @Published var selectedCluster: Cluster = .c1
    @Published var isModalPresented: Bool = false
    @Published var selectedSeat: ClusterSeatInfo? = nil
    
    @Published var c1Arr: [[ClusterSeatInfo]] = [[]]
    @Published var c2Arr: [[ClusterSeatInfo]] = [[]]
    @Published var c5Arr: [[ClusterSeatInfo]] = [[]]
    @Published var c6Arr: [[ClusterSeatInfo]] = [[]]
    @Published var cx1Arr: [[ClusterSeatInfo]] = [[]]
    @Published var cx2Arr: [[ClusterSeatInfo]] = [[]]
    
    func updateClusterArr(cluster: Cluster) async {

        let arr = await getClusterArr(cluster: cluster)
        switch cluster {
        case .c1:
            DispatchQueue.main.async {
                self.c1Arr = arr
            }
        case .c2:
            DispatchQueue.main.async {
                self.c2Arr = arr
            }
        case .c5:
            DispatchQueue.main.async {
                self.c5Arr = arr
            }
        case .c6:
            DispatchQueue.main.async {
                self.c6Arr = arr
            }
        case .cx1:
            DispatchQueue.main.async {
                self.cx1Arr = arr
            }
        case .cx2:
            DispatchQueue.main.async {
                self.cx2Arr = arr
            }
        }
    }
    
    func getClusterArr(cluster: Cluster) async -> [[ClusterSeatInfo]] {
        do {
            var arr = try await ClusterAPI.shared.getClusterMembersInfo(cluster)
            if cluster == .c2 || cluster == .c6 || cluster == .cx2 {
                arr = ClusterSeatInfo.resizeSeatArr(cluster: cluster, arr: arr)
            }
            return arr
        }
        catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            var arr = ClusterAPI.shared.getClusterArr(cluster)
            if cluster == .c2 || cluster == .c6 || cluster == .cx2 {
                arr = ClusterSeatInfo.resizeSeatArr(cluster: cluster, arr: arr)
            }
            return arr
        }
        catch {
            API.errorPrint(error, message: "Failed to get \(cluster.rawValue) ClusterArr")
            var arr = ClusterAPI.shared.getClusterArr(cluster)
            if cluster == .c2 || cluster == .c6 || cluster == .cx2 {
                arr = ClusterSeatInfo.resizeSeatArr(cluster: cluster, arr: arr)
            }
            return arr
        }
    }
    
    
    
    func addFriend(clusterSeat: ClusterSeatInfo) async -> Bool {
        do {
            let addFriendResult = try await GroupAPI.shared.addFriend(intraId: clusterSeat.id)
            return addFriendResult
        }
        catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        }
        catch {
            API.errorPrint(error, message: "Failed to add friend")
        }
        return false
    }
}

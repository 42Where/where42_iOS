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
    
    let clusterAPI = ClusterAPI()
    
    func updateClusterArr(cluster: Cluster) async {

        let arr = await getClusterArr(cluster: cluster)
        switch cluster {
        case .c1:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.c1Arr = arr
            }
        case .c2:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.c2Arr = arr
            }
        case .c5:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.c5Arr = arr
            }
        case .c6:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.c6Arr = arr
            }
        case .cx1:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.cx1Arr = arr
            }
        case .cx2:
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.cx2Arr = arr
            }
        }
    }
    
    func getClusterArr(cluster: Cluster) async -> [[ClusterSeatInfo]] {
        do {
            var arr = try await clusterAPI.getClusterArr(cluster)
            if cluster == .c2 || cluster == .c6 || cluster == .cx2 {
                arr = ClusterSeatInfo.resizeSeatArr(cluster: cluster, arr: arr)
            }
            return arr
        }
        catch NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            var arr = clusterAPI.getDefaultClusterArr(cluster)
            if cluster == .c2 || cluster == .c6 || cluster == .cx2 {
                arr = ClusterSeatInfo.resizeSeatArr(cluster: cluster, arr: arr)
            }
            return arr
        }
        catch {
            ErrorHandler.errorPrint(error, message: "Failed to get \(cluster.rawValue) ClusterArr")
            var arr = clusterAPI.getDefaultClusterArr(cluster)
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
        catch NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        }
        catch {
            ErrorHandler.errorPrint(error, message: "Failed to add friend")
        }
        return false
    }
}

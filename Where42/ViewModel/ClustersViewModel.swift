//
//  ClustersViewModel.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import Foundation

class ClustersViewModel: ObservableObject {
    @Published var selectedCluster: Cluster = .c1
    
    func getClusterArr(cluster: Cluster) async -> [[ClusterSeatInfo]] {
        do {
            var arr = try await ClusterAPI.shared.getClusterMembersInfo(cluster)
            return arr
        }
        catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
            return ClusterAPI.shared.getClusterArr(cluster)
        }
        catch {
            API.errorPrint(error, message: "Failed to get \(cluster.rawValue) ClusterArr")
            return ClusterAPI.shared.getClusterArr(cluster)
        }
    }
}

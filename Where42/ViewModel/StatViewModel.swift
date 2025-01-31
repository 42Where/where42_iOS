//
//  StatViewModel.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import Foundation
import SwiftUI

final class StatViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoaded: Bool = false
    @Published var clusterUsages: [SingleClusterUsage] = []
    @Published var iMacUsage: IMacUsageDTO = .init(usageRate: -1, usingImacUserCount: -1, totalUserCount: -1)
    @Published var userSeatHistory: [SingleUserSeatHistory] = []
    @Published var popularIMacs: [SinglePopularIMac] = []
    private var clusterUsagesDic: [String: SingleClusterUsage] = [:]
    
    // MARK: - Properties
    private let statAPI = StatAPI.shared
    
    // MARK: - Intializers
    init() {
        makeDefaultClusterUsages()
    }
}

extension StatViewModel {

    // MARK: - Method
    func fetchData() async {
        do {
            clusterUsagesDic = try await statAPI.getClusterUsage()
            let tmpIMacUsage = try await statAPI.getIMacUsage()
            let tmpUserSeatHistory = try await statAPI.getUserSeatHistory()
            let tmpPopularIMacs = try await statAPI.getPopularIMac()
            
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }

                self.iMacUsage = tmpIMacUsage
                self.userSeatHistory = tmpUserSeatHistory
                self.popularIMacs = tmpPopularIMacs
                self.isLoaded = true
            }

        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        } catch {
            API.errorPrint(error, message: "Failed to fetch data from StatAPI")
        }
    }
    
    func makeDefaultClusterUsages() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }

            if self.clusterUsages.count != 0 {
                self.clusterUsages.removeAll()
            }
            
            for cluster in Cluster.allCases {
                clusterUsages.append(SingleClusterUsage(name: cluster.rawValue))
            }
        }
    }
    
    func setClusterUsages() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for i in 0..<clusterUsages.count {
                self.clusterUsages[i].usageRate = self.clusterUsagesDic[clusterUsages[i].name]?.usageRate ?? 0
                self.clusterUsages[i].totalImacCount = self.clusterUsagesDic[clusterUsages[i].name]?.totalImacCount ?? 0
                self.clusterUsages[i].usingImacCount = self.clusterUsagesDic[clusterUsages[i].name]?.usingImacCount ?? 0
            }
        }
    }
}

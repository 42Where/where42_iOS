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
    @Published var iMacUsage: IMacUsageDTO = .init(usageRate: -1, usingImacUserCount: -1, totalUserCount: -1)
    @Published var userSeatHistory: [SingleUserSeatHistory] = []
    @Published var popularIMacs: [SinglePopularIMac] = []
    @Published var clusterUsagesDic: [String: SingleClusterUsage] = [:]
    
    // MARK: - Properties
    private let statAPI = StatAPI.shared
    private var clusterUsagesArr: [SingleClusterUsage] = []
    
    // MARK: - Intializers
    init() {
        makeDefaultClusterUsages()
    }
}

extension StatViewModel {

    // MARK: - Method
    func fetchData() async {
        do {
            clusterUsagesArr = try await statAPI.getClusterUsage()
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
            
            for cluster in Cluster.allCases {
                self.clusterUsagesDic[cluster.rawValue] = SingleClusterUsage(name: cluster.rawValue)
            }
        }
    }
    
    func setClusterUsages() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            for i in 0..<clusterUsagesArr.count {
                self.clusterUsagesDic[clusterUsagesArr[i].name] = self.clusterUsagesArr[i]
            }
        }
    }
}

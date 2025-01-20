//
//  StatViewModel.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import Foundation

final class StatViewModel: ObservableObject {

    // MARK: - Published Properties
    @Published var isLoading: Bool = true
    @Published var clusterUsages: [SingleClusterUsage] = []
    @Published var iMacUsage: IMacUsageDTO = .init(usageRate: -1, usingImacUserCount: -1)
    @Published var userSeatHistory: SingleUserSeatHistory = .init(seat: "", usingTimeHour: -1, usingTimeMinute: -1, usingTimeSecond: -1, usingCount: -1)
    @Published var popularIMacs: [SinglePopularIMac] = []
    
    // MARK: - Properties
    private let statAPI = StatAPI.shared
}

extension StatViewModel {

    // MARK: - Method
    func fetchData() async {
        do {
            clusterUsages = try await statAPI.getClusterUsage()
            iMacUsage = try await statAPI.getIMacUsage()
            userSeatHistory = try await statAPI.getUserSeatHistory()
            popularIMacs = try await statAPI.getPopularIMac()
            isLoading = false
        } catch API.NetworkError.Reissue {
            DispatchQueue.main.async {
                MainViewModel.shared.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            }
        } catch {
            API.errorPrint(error, message: "Failed to fetch data from StatAPI")
        }
    }
}

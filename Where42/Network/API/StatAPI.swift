//
//  StatAPI.swift
//  Where42
//
//  Created by ch on 1/17/25.
//

import Foundation

final class StatAPI: API {
    
    private enum StatURL: String {
        case clusterUsage = "/location/cluster/usage"
        case imacUsage = "/location/cluster/imacUsage"
        case userSeatHistory = "/analytics/seat-history?count=1"
        case popularImacCount = "/analytics/popular-imac?count=5"
    }
    
    private func generateURLRequest(_ statURL: StatURL) async throws -> URLRequest {
        let request = try await getURLRequest(subURL: statURL.rawValue, needContentType: false, needAccessToken: true)
        return request
    }
}

// MARK: - Cluster Usage
extension StatAPI {
    func getClusterUsage() async throws -> [SingleClusterUsage] {

        let request = try await generateURLRequest(.clusterUsage)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {

        case 200...299:
            let clustersUsage = try JSONDecoder().decode(ClusterUsageDTO.self, from: data)
            let clusterUsageArr = clustersUsage.clusters
            return clusterUsageArr

        case 300...599:
            try await handleAPIError(response: response, data: data)

        default:
            print("Failed Requesting StatAPI")
        }

        return [SingleClusterUsage(name: "", usageRate: -1, usingImacCount: -1, totalImacCount: -1)]
    }
}

// MARK: - iMac Usage
extension StatAPI {
    func getIMacUsage() async throws -> IMacUsageDTO {
        
        let request = try await generateURLRequest(.imacUsage)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200...299:
            let imacUsage = try JSONDecoder().decode(IMacUsageDTO.self, from: data)
            return imacUsage
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed Requesting StatAPI")
        }
        
        return IMacUsageDTO(usageRate: -1, usingImacUserCount: -1, totalUserCount: -1)
    }
}

// MARK: - User Seat History
extension StatAPI {
    func getUserSeatHistory() async throws -> [SingleUserSeatHistory] {
        
        let request = try await generateURLRequest(.userSeatHistory)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200...299:
            let singleUserSeatHistory = try JSONDecoder().decode(UserSeatHistoryDTO.self, from: data)
            return singleUserSeatHistory.seats
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed Requesting StatAPI")
        }
        
        return [SingleUserSeatHistory(seat: "", usingTimeHour: -1, usingTimeMinute: -1, usingTimeSecond: -1, usingCount: -1)]
    }
}

// MARK: - Popular iMac
extension StatAPI {
    func getPopularIMac() async throws -> [SinglePopularIMac] {
        
        let request = try await generateURLRequest(.popularImacCount)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
        case 200...299:
            let popularIMacArr = try JSONDecoder().decode(PopularIMacDTO.self, from: data)
            return popularIMacArr.seats
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default:
            print("Failed Requesting StatAPI")
        }
        
        return [SinglePopularIMac(seat: "", usingTimeHour: -1, usingTimeMinute: -1, usingTimeSecond: -1, usingUserCount: -1)]
    }
}

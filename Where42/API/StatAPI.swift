//
//  StatAPI.swift
//  Where42
//
//  Created by ch on 1/17/25.
//

import Foundation

// MARK: - DTOs

struct SingleClusterUsage: Codable {
    // MARK: - Properties
    var name: String
    var usageRate: Int
    var usingImacCount: Int
    var totalImacCount: Int
    
    // MARK: - Initializers
    init(name: String, usageRate: Int, usingImacCount: Int, totalImacCount: Int) {
        self.name = name
        self.usageRate = usageRate
        self.usingImacCount = usingImacCount
        self.totalImacCount = totalImacCount
    }
    
    init(name: String) {
        self.name = name
        self.usageRate = 0
        self.usingImacCount = 0
        self.totalImacCount = 0
    }
}
struct ClusterUsageDTO: Codable {
    var clusters: [SingleClusterUsage]
}

struct IMacUsageDTO: Codable {
    var usageRate: Int
    var usingImacUserCount: Int
    var totalUserCount: Int
}

struct SingleUserSeatHistory: Codable {
    var seat: String
    var usingTimeHour: Int
    var usingTimeMinute: Int
    var usingTimeSecond: Int
    var usingCount: Int
}
struct UserSeatHistoryDTO: Codable {
    var seats: [SingleUserSeatHistory]
}

struct SinglePopularIMac: Codable {
    var seat: String
    var usingTimeHour: Int
    var usingTimeMinute: Int
    var usingTimeSecond: Int
    var usingUserCount: Int
}
struct PopularIMacDTO: Codable {
    var seats: [SinglePopularIMac]
}

// MARK: - StatAPI

final class StatAPI: API {
    
    static let shared = StatAPI()
    
    private enum StatURL: String {
        case clusterUsage = "/location/cluster/usage"
        case imacUsage = "/location/cluster/imacUsage"
        case userSeatHistory = "/analytics/seat-history?count=1"
        case popularImacCount = "/analytics/popular-imac?count=5"
    }
    
    private func generateURLRequest(_ statURL: StatURL) async throws -> URLRequest {

        guard let requestURL = URL(string: baseURL + statURL.rawValue) else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        
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

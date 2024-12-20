//
//  ClusterAPI.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import Foundation

struct CurrentLoggedInMembersDTO: Decodable {
    var members: [LoggedInMemberInfoDTO]
}

struct LoggedInMemberInfoDTO: Decodable {
    var memberId: Int
    var intraName: String
    var image: String
    var cluster: String
    var row: Int
    var seat: Int
    var isFriend: Bool
}

class ClusterAPI: API {
    
    static let shared = ClusterAPI()
    
    func getClusterMembersInfo(_ cluster: Cluster) async throws -> [[ClusterSeatInfo]] {
        
        var seatArr = getClusterArr(cluster)
        
        guard let requestURL = URL(string: baseURL + "/cluster/" + cluster.rawValue) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: requestURL)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        try await request.addValue(API.sharedAPI.getAccessToken(), forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
            
        case 200...299:
            let decodedResponse = try JSONDecoder().decode(CurrentLoggedInMembersDTO.self, from: data)
            let loggedInMembersInfo = decodedResponse.members
            if loggedInMembersInfo.isEmpty { return seatArr }
            
            for i in 0..<loggedInMembersInfo.count {
                let r = loggedInMembersInfo[i].row
                let s = loggedInMembersInfo[i].seat
                seatArr[r][s].isLoggedIn = true
                seatArr[r][s].intraName = loggedInMembersInfo[i].intraName
                seatArr[r][s].image = loggedInMembersInfo[i].image
                seatArr[r][s].cluster = loggedInMembersInfo[i].cluster
                seatArr[r][s].row = loggedInMembersInfo[i].row
                seatArr[r][s].seat = loggedInMembersInfo[i].seat
                seatArr[r][s].isFriend = loggedInMembersInfo[i].isFriend
            }
            
            return seatArr
            
        case 300...399:
            throw NetworkError.BadRequest
            
        case 400...499:
            let response = String(data: data, encoding: String.Encoding.utf8)!
            if response.contains("errorCode") && response.contains("errorMessage") {
                let customException = parseCustomException(response: response)
                if customException.handleError() == false {
                    try await API.sharedAPI.reissue()
                    throw NetworkError.Reissue
                }
            } else {
                throw NetworkError.BadRequest
            }
            
        case 500...599:
            throw NetworkError.ServerError
            
        default: print("Failed Requesting Recent Version")
            
        }
        
        return seatArr

    }
    
    func getClusterArr(_ cluster: Cluster) -> [[ClusterSeatInfo]] {
        switch cluster {
        case .c1, .c5:
            return Array(repeating: Array(repeating: ClusterSeatInfo(), count: 8), count: 10)
        case .c2, .c6:
            return Array(repeating: Array(repeating: ClusterSeatInfo(), count: 9), count: 11)
        case .cx1:
            return Array(repeating: Array(repeating: ClusterSeatInfo(), count: 9), count: 6)
        case .cx2:
            return Array(repeating: Array(repeating: ClusterSeatInfo(), count: 11), count: 9)
        }
    }
    
}

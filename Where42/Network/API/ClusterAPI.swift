//
//  ClusterAPI.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import Foundation

final class ClusterAPI: API {
    
    func getClusterArr(_ cluster: Cluster) async throws -> [[ClusterSeatInfo]] {
        var request = try await getURLRequest(subURL: "/location/active/", needContentType: true, needAccessToken: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
            
        case 200...299:
            let decodedResponse = try JSONDecoder().decode(CurrentLoggedInMembersDTO.self, from: data)
            let loggedInMembersInfo = decodedResponse.members
            return getUpdatedClusterArr(cluster, loggedInMembersInfo)
            
        case 300...599:
            try await handleAPIError(response: response, data: data)
            
        default: print("Failed Requesting ClusterAPI")
        }
        
        return getDefaultClusterArr(cluster)
    }
    
    private func getUpdatedClusterArr(_ cluster: Cluster, _ loggedInMembersInfo: [LoggedInMemberInfoDTO]) -> [[ClusterSeatInfo]] {
        var seatArr = getDefaultClusterArr(cluster)

        if loggedInMembersInfo.isEmpty { return seatArr }
        
        for i in 0..<loggedInMembersInfo.count {
            let r = loggedInMembersInfo[i].row
            let s = loggedInMembersInfo[i].seat
            
            if r > seatArr.count || s > seatArr[0].count { continue }
            
            seatArr[r - 1][s - 1].id = loggedInMembersInfo[i].intraId
            seatArr[r - 1][s - 1].isLoggedIn = true
            seatArr[r - 1][s - 1].intraName = loggedInMembersInfo[i].intraName
            seatArr[r - 1][s - 1].image = loggedInMembersInfo[i].image ?? "nil"
            seatArr[r - 1][s - 1].cluster = loggedInMembersInfo[i].cluster
            seatArr[r - 1][s - 1].row = loggedInMembersInfo[i].row
            seatArr[r - 1][s - 1].seat = loggedInMembersInfo[i].seat
            seatArr[r - 1][s - 1].isFriend = loggedInMembersInfo[i].isFriend
        }
        
        return seatArr
    }
    
    func getDefaultClusterArr(_ cluster: Cluster) -> [[ClusterSeatInfo]] {

        var arr: [[ClusterSeatInfo]]

        switch cluster {
        case .c1:
            arr = Array(repeating: Array(repeating: ClusterSeatInfo(cluster: "c1"), count: 7), count: 9)
        case .c2:
            arr = Array(repeating: Array(repeating: ClusterSeatInfo(cluster: "c2"), count: 8), count: 10)
        case .c5:
            arr = Array(repeating: Array(repeating: ClusterSeatInfo(cluster: "c5"), count: 7), count: 9)
        case .c6:
            arr = Array(repeating: Array(repeating: ClusterSeatInfo(cluster: "c6"), count: 8), count: 10)
        case .cx1:
            arr = Array(repeating: Array(repeating: ClusterSeatInfo(cluster: "cx1"), count: 8), count: 5)
        case .cx2:
            arr = Array(repeating: Array(repeating: ClusterSeatInfo(cluster: "cx2"), count: 10), count: 8)
        }

        for row in 0..<arr.count {
            for seat in 0..<arr[row].count {
                arr[row][seat].id = row * 10 + seat
                arr[row][seat].row = row + 1
                arr[row][seat].seat = seat + 1
            }
        }
        
        return arr
    }
    
}

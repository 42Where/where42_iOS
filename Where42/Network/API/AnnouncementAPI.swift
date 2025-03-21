//
//  AnnouncementAPI.swift
//  Where42
//
//  Created by 이창현 on 11/20/24.
//

import Foundation

final class AnnouncementAPI: API {
    
    var announcementList: [Announcement] = []
    
    func getAnnouncementList() async throws -> [Announcement] {
        var request = try await getURLRequest(subURL: "/announcement?page=0&size=5", needContentType: true, needAccessToken: true)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.invalidHTTPResponse
        }
        
        switch response.statusCode {
            
        case 200...299:
            let decodedResponse = try JSONDecoder().decode(ResponseAnnouncementsDTO.self, from: data)
            let receivedAnnouncements = decodedResponse.announcements
            if receivedAnnouncements.isEmpty { return announcementList }
            
            if !announcementList.isEmpty {
                self.announcementList.removeAll()
            }
            
            for i in 0..<receivedAnnouncements.count {
                let newAnnouncement = Announcement(
                    id: receivedAnnouncements[i].announcementId,
                    title: receivedAnnouncements[i].title,
                    content: receivedAnnouncements[i].content,
                    authorName: receivedAnnouncements[i].authorName,
                    createAt: receivedAnnouncements[i].createAt,
                    updateAt: receivedAnnouncements[i].updateAt
                )
                self.announcementList.append(newAnnouncement)
            }
            
            return announcementList
            
        case 300...599:
            try await handleAPIError(response: response, data: data)
        default: print("Failed Requesting Recent Version")
        }
        return announcementList
    }
}

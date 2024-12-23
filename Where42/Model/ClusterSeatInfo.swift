//
//  ClusterMemberInfo.swift
//  Where42
//
//  Created by ch on 12/16/24.
//

import Foundation

struct ClusterSeatInfo: Identifiable {
    var id: Int = -1
    var isLoggedIn: Bool = false
    var intraName: String = ""
    var image: String = ""
    var cluster: String = ""
    var row: Int = -1
    var seat: Int = -1
    var isFriend: Bool = false
    
    func isValidSeat() -> Bool {
        if cluster == "cx1" {
            switch row {
            case 1, 2, 3:
                return seat >= 1 && seat <= 4
            case 4, 5:
                return seat >= 1 && seat <= 8
            default:
                return true
            }
        } else if cluster == "cx2" {
            switch row {
            case 1, 8:
                return seat >= 1 && seat <= 4
            case 2, 7:
                return seat >= 1 && seat <= 10
            case 3, 6:
                return seat >= 1 && seat <= 8
            case 4, 5:
                return seat >= 1 && seat <= 6
            default:
                return false
            }
        }
        return true
    }
    
    static func resizeSeatArr(cluster: Cluster, arr: [[ClusterSeatInfo]]) -> [[ClusterSeatInfo]]{
        var retArr: [[ClusterSeatInfo]] = arr
        switch cluster {
        case .cx2:
            for i in 0...7 {
                switch i {
                case 0, 7:
                    retArr[i] = retArr[i].filter {
                        $0.seat >= 1 && $0.seat <= 4
                    }
                    for _ in 0...2 {
                        retArr[i].insert(ClusterSeatInfo(cluster: "cx2"), at: 0)
                    }
                    for _ in 0...2 {
                        retArr[i].append(ClusterSeatInfo(cluster: "cx2"))
                    }
                case 1, 6:
                    retArr[i] = retArr[i].filter {
                        $0.seat >= 1 && $0.seat <= 10
                    }
                case 2, 5:
                    retArr[i] = retArr[i].filter {
                        $0.seat >= 1 && $0.seat <= 8
                    }
                    retArr[i].insert(ClusterSeatInfo(cluster: "cx2"), at: 0)
                    retArr[i].append(ClusterSeatInfo(cluster: "cx2"))
                case 3, 4:
                    retArr[i] = retArr[i].filter {
                        $0.seat >= 1 && $0.seat <= 6
                    }
                    for _ in 0...1 {
                        retArr[i].insert(ClusterSeatInfo(cluster: "cx2"), at: 0)
                    }
                    for _ in 0...1 {
                        retArr[i].append(ClusterSeatInfo(cluster: "cx2"))
                    }
                default:
                    continue
                }
            }
            return retArr
        default:
            return arr
        }
    }
}

//
//  Seat+SeatTextView.swift
//  Where42
//
//  Created by ch on 12/25/24.
//

import SwiftUI
import Kingfisher

struct Seat_SeatTextView: View {
    
    @EnvironmentObject private var clustersViewModel: ClustersViewModel
    var seat: ClusterSeatInfo
    var frameWidth: CGFloat
    
    init(seat: ClusterSeatInfo = ClusterSeatInfo(), frameWidth: CGFloat = 24) {
        self.seat = seat
        self.frameWidth = frameWidth
    }
    
    var body: some View {
        VStack {
            if seat.isLoggedIn {
                if let url = URL(string: seat.image) {
                    Button {
                        clustersViewModel.selectedSeat = seat
                        clustersViewModel.isModalPresented = true
                    } label: {
                        if seat.isFriend {
                            KFImage(url)
                                .resizable()
                                .placeholder {
                                    Image("Imac icon")
                                        .resizable()
                                        .frame(width: frameWidth, height: frameWidth)
                                }
                                .overlay(Rectangle().stroke(.whereDeepPink, lineWidth: 2))
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameWidth)
                        }
                        else {
                            KFImage(url)
                                .resizable()
                                .placeholder {
                                    Image("Imac icon")
                                        .resizable()
                                        .frame(width: frameWidth, height: frameWidth)
                                }
                                .scaledToFit()
                                .frame(width: frameWidth, height: frameWidth)
                        }
                    }
                    
                }
            } else {
                Image("Imac icon")
                    .resizable()
                    .frame(width: frameWidth, height: frameWidth)
            }
            Text("\(seat.seat)")
                .foregroundStyle(.whereDeepNavy)
                .font(.GmarketMedium14)
                .monospaced()
        }
    }
}

#Preview {
    Seat_SeatTextView()
}

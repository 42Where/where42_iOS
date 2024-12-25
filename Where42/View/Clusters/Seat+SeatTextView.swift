//
//  Seat+SeatTextView.swift
//  Where42
//
//  Created by ch on 12/25/24.
//

import SwiftUI
import Kingfisher

struct Seat_SeatTextView: View {
    
    var seat: ClusterSeatInfo = ClusterSeatInfo()
    
    var body: some View {
        VStack {
            if seat.isLoggedIn {
                if let url = URL(string: seat.image) {
                    if seat.isFriend {
                        KFImage(url)
                            .resizable()
                            .frame(width: 21, height: 21)
                            .overlay(Rectangle().stroke(.whereDeepPink, lineWidth: 1))
                    }
                    else {
                        KFImage(url)
                            .resizable()
                            .frame(width: 21, height: 21)
                    }
                }
            } else {
                Image("Imac icon")
                    .resizable()
                    .frame(width: 21, height: 21)
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

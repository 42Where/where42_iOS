//
//  CxR1R2R3View.swift
//  Where42
//
//  Created by ch on 12/25/24.
//

import SwiftUI
import Kingfisher

struct Cx1R1R2R3View: View {
    
    var seats: [ClusterSeatInfo] = Array(repeating: ClusterSeatInfo(), count: 4)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.5))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                    
                    path.move(to: CGPoint(x: 0, y: geometry.size.height * 0.5))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                }
                .stroke(Color.black, lineWidth: 2)
                Seat_SeatTextView(seat: seats[3])
                    .frame(width: 21, height: 30)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.1)
                Seat_SeatTextView(seat: seats[2])
                    .frame(width: 21, height: 30)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.3)
                Seat_SeatTextView(seat: seats[1])
                    .frame(width: 21, height: 30)
                    .position(x: geometry.size.width * 0.9, y: geometry.size.height * 0.7)
                Seat_SeatTextView(seat: seats[0])
                    .frame(width: 21, height: 30)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.9)
            }
        }
    }
}

#Preview {
    Cx1R1R2R3View()
}

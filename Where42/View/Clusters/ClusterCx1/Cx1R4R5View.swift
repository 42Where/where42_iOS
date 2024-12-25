//
//  Cx1R4R5View.swift
//  Where42
//
//  Created by ch on 12/25/24.
//

import SwiftUI

struct Cx1R4R5View: View {
    
    var seats: [ClusterSeatInfo] = Array(repeating: ClusterSeatInfo(), count: 8)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: geometry.size.height))
                    
                    path.move(to: CGPoint(x: 0, y: geometry.size.height))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
                }
                .stroke(Color.black, lineWidth: 2)
            }
            Seat_SeatTextView(seat: seats[7])
                .frame(width: 21, height: 30)
                .position(x: geometry.size.width, y: geometry.size.height * 0.3)
            Seat_SeatTextView(seat: seats[6])
                .frame(width: 21, height: 30)
                .position(x: geometry.size.width * 0.7, y: 0)
            Seat_SeatTextView(seat: seats[5])
                .frame(width: 21, height: 30)
                .position(x: geometry.size.width * 0.3, y: 0)
            Seat_SeatTextView(seat: seats[4])
                .frame(width: 21, height: 30)
                .position(x: 0, y: geometry.size.height * 0.3)
            Seat_SeatTextView(seat: seats[3])
                .frame(width: 21, height: 30)
                .position(x: geometry.size.width, y: geometry.size.height * 0.7)
            Seat_SeatTextView(seat: seats[2])
                .frame(width: 21, height: 30)
                .position(x: geometry.size.width * 0.3, y: geometry.size.height)
            Seat_SeatTextView(seat: seats[1])
                .frame(width: 21, height: 30)
                .position(x: geometry.size.width * 0.7, y: geometry.size.height)
            Seat_SeatTextView(seat: seats[0])
                .frame(width: 21, height: 30)
                .position(x: 0, y: geometry.size.height * 0.7)
        }
    }
}

#Preview {
    Cx1R4R5View()
}

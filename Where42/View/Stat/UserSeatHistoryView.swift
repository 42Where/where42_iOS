//
//  UserSeatHistoryView.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import SwiftUI

struct UserSeatHistoryView: View {
    
    @EnvironmentObject var statViewModel: StatViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            Text("지난주에 자주 앉은 자리")
                .font(.GmarketMedium18)
            Spacer(minLength: 16)
            if statViewModel.userSeatHistory.count == 0 {
                Text("자리 정보가 없습니다")
                    .font(.GmarketLight18)
            } else {
                Text("\(statViewModel.userSeatHistory[0].seat.uppercased())")
                    .font(.GmarketBold18)
            }
            Spacer()
        }
        .padding(EdgeInsets(top: 16, leading: 20, bottom: 16, trailing: 20))
        .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 1.0))
    }
}

#Preview {
    UserSeatHistoryView()
        .environmentObject(StatViewModel())
}

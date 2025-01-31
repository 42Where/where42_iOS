//
//  PopularImacView.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import SwiftUI

struct PopularImacView: View {
    
    @EnvironmentObject var statViewModel: StatViewModel
    
    var body: some View {
        LazyVStack(spacing: 8) {
            Text("지난주 인기자리")
                .font(.GmarketMedium18)
            
            Spacer()
            
            if statViewModel.popularIMacs.count == 0 {
                Text("자리 정보가 없습니다")
                    .font(.GmarketLight18)
            } else {
                getRankText(rank: 1)
                getRankText(rank: 2)
                getRankText(rank: 3)
                getRankText(rank: 4)
                getRankText(rank: 5)
            }
        }
        .padding(EdgeInsets(top: 16, leading: 50, bottom: 16, trailing: 50))
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black, lineWidth: 1.0)
        )
    }
    
    @ViewBuilder
    private func getRankText(rank: Int) -> some View {
        switch rank {
        case 1:
            HStack {
                Text("\(rank)")
                    .font(.GmarketBold18)
                Spacer()
                Text("\(statViewModel.popularIMacs[rank - 1].seat.uppercased())")
                    .font(.GmarketBold18)
                    .frame(width: 100)
            }
        case 2, 3, 4, 5:
            if isRankValid(rank) {
                HStack {
                    Text("\(rank)")
                        .font(.GmarketLight18)
                    Spacer()
                    Text("\(statViewModel.popularIMacs[rank - 1].seat.uppercased())")
                        .font(.GmarketLight18)
                        .frame(width: 100)
                }
            }
        default:
            Text("")
        }
    }
    
    private func isRankValid(_ rank: Int) -> Bool {
        return statViewModel.popularIMacs.count >= rank
    }
}

#Preview {
    PopularImacView()
        .environmentObject(StatViewModel())
}

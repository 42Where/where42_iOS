//
//  IMacUsageView.swift
//  Where42
//
//  Created by 이창현 on 1/20/25.
//

import SwiftUI

struct IMacUsageView: View {
    
    @EnvironmentObject var statViewModel: StatViewModel
    
    var body: some View {
        LazyVStack(spacing: 6) {
            Spacer()
            Text("클러스터 iMac 사용 현황")
                .font(.GmarketMedium18)
            Text("(iMac 로그인 인원 / 출석 태깅한 인원)")
                .font(.GmarketMedium14)
            Spacer()
            Text("\(statViewModel.iMacUsage.usingImacUserCount) / \(statViewModel.iMacUsage.totalUserCount)")
                .font(.GmarketBold18)
            Spacer()
        }
        .overlay(RoundedRectangle(cornerRadius: 8)
            .stroke(Color.black, lineWidth: 1.0)
        )
    }
}

#Preview {
    IMacUsageView()
        .environmentObject(StatViewModel())
}

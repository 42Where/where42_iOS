//
//  LaunchScreen.swift
//  Where42
//
//  Created by 현동호 on 10/30/23.
//

import SwiftUI

struct LaunchScreenView: View {
    var body: some View {
        VStack {
            Image("Logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 110)
                .padding(.top, 110)

            Text("로딩중")
                .font(.custom("GmarketSansTTFBold", size: 35.0))
                .foregroundStyle(.whereDeepNavy)
                .padding(.top, 90)

            Spacer()
        }
    }
}

#Preview {
    LaunchScreenView()
}

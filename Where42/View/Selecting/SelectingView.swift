//
//  SearchViewForSelect.swift
//  Where42
//
//  Created by 현동호 on 11/14/23.
//

import SwiftUI

struct SelectingView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @State private var isShowSheet = false
    @State private var name: String = ""

    var body: some View {
        NavigationView {
            VStack {
                VStack {
                    HStack {
                        Image("Search icon M")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20)
                        TextField("이름을 입력해주세요", text: $name)
                    }
                    .padding()
                    .foregroundStyle(.whereDeepNavy)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.whereDeepNavy, lineWidth: 2)
                    )

                    ForEach($homeViewModel.friends.members, id: \.self) { $user in
                        SelectingFriendInfoView(userInfo: $user)
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding()

                HStack {
                    Spacer()

                    Button {
                        Task {
                            await homeViewModel.createNewGroup(intraId: homeViewModel.intraId)
                        }
                        mainViewModel.isSelectViewPrsented = false
                    } label: {
                        Text("그룹 추가하기")
                            .font(.custom(Font.GmarketMedium, size: 20))
                            .foregroundStyle(.white)
                    }
                    .clipShape(Rectangle())
                    .padding()

                    Spacer()
                }
                .background(.whereDeepNavy)
                .ignoresSafeArea()
            }
            .toolbar {
                Where42ToolBarContent(isShowSheet: $isShowSheet, isSettingPresenting: false)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    SelectingView()
        .environmentObject(HomeViewModel())
}

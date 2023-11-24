//
//  SearchViewForSelect.swift
//  Where42
//
//  Created by 현동호 on 11/14/23.
//

import SwiftUI

struct SelectingView: View {
    @EnvironmentObject var mainViewModel: MainViewModel
    @EnvironmentObject var homeViewModel: HomeViewModel

    @State private var isShowSheet = false
    @State private var name: String = ""

    @State var dhyun: UserInfo = .init(name: "dhyun", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "퇴근", comment: "안녕하세요~")

    private var selectedUser: [UserInfo] = []

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

                    ForEach($homeViewModel.searching.users, id: \.self) { $user in
                        SelectingFriendInfoView(userInfo: $user)
                            .padding(.top)
                    }

                    Spacer()
                }
                .padding()

                HStack {
                    Spacer()

                    Button {
                        homeViewModel.createNewGroup()
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

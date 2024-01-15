//
//  SearchView.swift
//  Where42
//
//  Created by 현동호 on 10/28/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchViewModel: SearchViewModel = .init()

    @State private var isShowSheet = false
    @State private var name: String = ""

    var isSelected = false

    @State private var member12 = MemberInfo(intraId: 12, intraName: "member12", image: "https://i.ibb.co/M1wyzZV/IMG-6196.jpg", comment: "nil", inCluster: false, location: "퇴근")

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

                    HomeFriendInfoView(
                        userInfo: $member12,
                        groupInfo: $searchViewModel.searching
                    )
                    .padding(.top)

                    Spacer()
                }
                .padding()

                if isSelected {
                    HStack {
                        Spacer()
                        Button {} label: {
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
            }
            .toolbar {
                Where42ToolBarContent(isShowSheet: $isShowSheet, isSettingPresenting: false)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    SearchView()
        .environmentObject(HomeViewModel())
}

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
        VStack {
            VStack {
                HStack {
                    Image("Search icon M")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    TextField("이름을 입력해주세요", text: $name)
                        .textInputAutocapitalization(.never)

                    Spacer()

                    if name != "" {
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                name = ""
                            }
                    }
                }
                .padding()
                .foregroundStyle(.whereDeepNavy)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.whereDeepNavy, lineWidth: 2)
                )

                ScrollView {
                    LazyVStack {
                        ForEach(0 ..< homeViewModel.friends.members.count, id: \.self) { index in
                            if name == "" || (homeViewModel.friends.members[index].intraName?.contains(name.lowercased())) == true {
                                if UIDevice.idiom == .phone {
                                    SelectingFriendInfoView(userInfo: $homeViewModel.friends.members[index])
                                        .padding(.top)
                                        .padding(.leading, 3)
                                } else if UIDevice.idiom == .pad {
                                    if index % 2 == 0 {
                                        HStack {
                                            SelectingFriendInfoView(userInfo: $homeViewModel.friends.members[index])
                                                .padding([.top, .leading, .trailing])
                                            if index + 1 < homeViewModel.friends.members.count {
                                                SelectingFriendInfoView(userInfo: $homeViewModel.friends.members[index + 1])
                                                    .padding([.top, .leading, .trailing])
                                            } else {
                                                Spacer()
                                                    .padding()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
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
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    SelectingView()
        .environmentObject(HomeViewModel())
}

//
//  SearchView.swift
//  Where42
//
//  Created by 현동호 on 10/28/23.
//

import SwiftUI

struct SearchView: View {
    @StateObject var searchViewModel: SearchViewModel = .init()
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @State private var isShowSheet = false
    @State private var name: String = ""

    var body: some View {
        VStack {
            HStack {
                Image("Search icon M")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                TextField("이름을 입력해주세요", text: $name)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()

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
            .padding([.horizontal, .top])

            ScrollView {
                LazyVStack {
                    ForEach(0 ..< homeViewModel.friends.members.count, id: \.self) { index in
                        if homeViewModel.friends.members[index].isCheck == true ||
                            name == "" ||
                            (homeViewModel.friends.members[index].intraName?.contains(name.lowercased())) == true
                        {
                            if UIDevice.idiom == .phone {
                                SearchMemberInfoView(userInfo: $homeViewModel.friends.members[index])
                                    .padding(.top)
                                    .onAppear {
                                        homeViewModel.viewPresentCount += 1
                                    }
                                    .onDisappear {
                                        homeViewModel.viewPresentCount -= 1
                                    }
                            } else if UIDevice.idiom == .pad {
                                if index % 2 == 0 {
                                    HStack {
                                        SearchMemberInfoView(userInfo: $homeViewModel.friends.members[index])
                                            .padding([.top, .horizontal])
                                            .onAppear {
                                                homeViewModel.viewPresentCount += 1
                                            }
                                            .onDisappear {
                                                homeViewModel.viewPresentCount -= 1
                                            }
                                        if index + 1 < homeViewModel.friends.members.count {
                                            SearchMemberInfoView(userInfo: $homeViewModel.friends.members[index + 1])
                                                .padding([.top, .horizontal])
                                                .onAppear {
                                                    homeViewModel.viewPresentCount += 1
                                                }
                                                .onDisappear {
                                                    homeViewModel.viewPresentCount -= 1
                                                }
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
                .padding([.horizontal, .bottom])
                .onAppear {
                    homeViewModel.viewPresentCount = 0
                }
            }

            Spacer()

            if homeViewModel.selectedUsers.count > 0 {
                HStack {
                    Spacer()

                    Button {
                        print(homeViewModel.viewPresentCount)
                        Task {
//                            await homeViewModel.addMemberInGroup(groupId: homeViewModel.selectedGroup.groupId!)
                        }
                    } label: {
                        Text("친구 추가하기")
                            .font(.custom(Font.GmarketMedium, size: 20))
                            .foregroundStyle(.white)
                    }
                    .clipShape(Rectangle())
                    .padding()

                    Spacer()
                }
                .background(.whereDeepNavy)
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar(homeViewModel.selectedUsers.count > 0 ? .hidden : .visible, for: .tabBar)
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    SearchView()
        .environmentObject(HomeViewModel())
}

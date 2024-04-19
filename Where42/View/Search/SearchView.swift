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
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Image("Search icon M")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 20)
                    TextField("2글자 이상 입력해주세요", text: $searchViewModel.name)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    
                    if searchViewModel.name != "" {
                        Image(systemName: "xmark.circle.fill")
                            .onTapGesture {
                                searchViewModel.name = ""
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
                
                if searchViewModel.selectedMembers.count > 0 {
                    SearchSelectedMembersView()
                        .disabled(searchViewModel.searchStatus != .waiting)
                }
                    
                if searchViewModel.searching.count == 0 && searchViewModel.searchStatus == .waiting {
                    Spacer()
                        
                    Text("아무도 없어요...")
                        .font(.custom(Font.GmarketBold, size: 20))
                        
                    Spacer()
                } else {
                    ScrollView {
                        ForEach(0 ..< searchViewModel.searching.count, id: \.self) { index in
                            if searchViewModel.name == "" ||
                                (searchViewModel.searching[index].intraName.contains(searchViewModel.name.lowercased())) == true
                            {
                                if UIDevice.idiom == .phone {
                                    SearchMemberInfoView(memberInfo: $searchViewModel.searching[index])
                                        .padding(index == 0 && searchViewModel.selectedMembers.count != 0 ? [] : .top)
                                } else if UIDevice.idiom == .pad {
                                    if index % 2 == 0 {
                                        HStack {
                                            SearchMemberInfoView(memberInfo: $searchViewModel.searching[index])
                                                .padding([index == 0 && searchViewModel.selectedMembers.count != 0 ? [] : .top, .horizontal])
                                            if index + 1 < searchViewModel.searching.count {
                                                SearchMemberInfoView(memberInfo: $searchViewModel.searching[index + 1])
                                                    .padding([index == 0 && searchViewModel.selectedMembers.count != 0 ? [] : .top, .horizontal])
                                            } else {
                                                Spacer()
                                                    .padding()
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        .padding([.horizontal, .bottom])
                    }
                    .disabled(searchViewModel.searchStatus != .waiting)
                        
                    Spacer()
                }
                    
                if searchViewModel.selectedMembers.count > 0 {
                    HStack {
                        Spacer()
                            
                        Button {
                            Task {
                                if await searchViewModel.addMemberInGroup(groupId: homeViewModel.friends.groupId) {
                                    searchViewModel.initSearchingAfterAdd()
                                    await homeViewModel.getGroup()
                                }
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
                    .disabled(searchViewModel.searchStatus != .waiting)
                }
            }
                
            if searchViewModel.searchStatus != .waiting {
                ProgressView()
                    .scaleEffect(2)
                    .progressViewStyle(.circular)
            }
        }
        .environmentObject(searchViewModel)
        .onChange(of: searchViewModel.name) { newValue in
            Task {
                if newValue.count >= 2 && newValue.count < 10 {
                    searchViewModel.publisher.send(newValue)
                    searchViewModel.searchStatus = .searching
                } else {
                    searchViewModel.searching = []
                    searchViewModel.searchStatus = .waiting
                }
            }
        }
        .onReceive(
            searchViewModel.publisher.debounce(
                for: .seconds(searchViewModel.debounceSeconds),
                scheduler: DispatchQueue.main
            )
        ) { newValue in
            searchViewModel.search(keyWord: newValue)
        }
        .onSubmit {
            if searchViewModel.searchStatus == .waiting {
                searchViewModel.searchStatus = .searching
            }
            searchViewModel.search(keyWord: searchViewModel.name)
        }
        .submitLabel(.search)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar(searchViewModel.isTabBarPresented ? .hidden : .visible, for: .tabBar)
        .transition(.move(edge: .bottom))
        .contentShape(Rectangle())
        .hideKeyboardOnTap()
    }
}

#Preview {
    SearchView()
        .environmentObject(HomeViewModel())
}

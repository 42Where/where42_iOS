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
                
                if searchViewModel.searching.count == 0 {
                    Spacer()
                    
                    Text("아무도 없어요...")
                        .font(.custom(Font.GmarketBold, size: 20))
                    
                    Spacer()
                } else {
                    ScrollView {
                        LazyVStack {
                            ForEach(0 ..< searchViewModel.searching.count, id: \.self) { index in
                                if searchViewModel.searching[index].isCheck == true ||
                                    searchViewModel.name == "" ||
                                    (searchViewModel.searching[index].intraName?.contains(searchViewModel.name.lowercased())) == true
                                {
                                    if UIDevice.idiom == .phone {
                                        SearchMemberInfoView(userInfo: $searchViewModel.searching[index])
                                            .padding(.top)
                                    } else if UIDevice.idiom == .pad {
                                        if index % 2 == 0 {
                                            HStack {
                                                SearchMemberInfoView(userInfo: $searchViewModel.searching[index])
                                                    .padding([.top, .horizontal])
                                                if index + 1 < searchViewModel.searching.count {
                                                    SearchMemberInfoView(userInfo: $searchViewModel.searching[index + 1])
                                                        .padding([.top, .horizontal])
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
                }
                
                if homeViewModel.selectedMembers.count > 0 {
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
            
            if searchViewModel.isSearching {
                ProgressView()
            }
        }
        .onChange(of: searchViewModel.name) { newValue in
            Task {
                if newValue.count >= 2 {
                    searchViewModel.isSearching = true
                    
                    searchViewModel.publisher.send(newValue)
                    
                } else {
                    searchViewModel.searching = []
                }
            }
        }
        .onReceive(
            searchViewModel.publisher.debounce(
                for: .seconds(searchViewModel.debounceSeconds),
                scheduler: DispatchQueue.main
            )
        ) { newValue in
            Task {
                await searchViewModel.searchMemeber(keyWord: newValue)
                searchViewModel.isSearching = false
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .toolbar(homeViewModel.selectedMembers.count > 0 ? .hidden : .visible, for: .tabBar)
        .transition(.move(edge: .bottom))
    }
}

#Preview {
    SearchView()
        .environmentObject(HomeViewModel())
}

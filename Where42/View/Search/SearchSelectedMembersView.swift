//
//  SelectedMembersView.swift
//  Where42
//
//  Created by 현동호 on 2/22/24.
//

import Kingfisher
import SwiftUI

struct SearchSelectedMembersView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var searchViewModel: SearchViewModel

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 5) {
                ForEach(0 ..< homeViewModel.selectedMembers.count, id: \.self) { index in
                    VStack {
                        ZStack {
                            VStack {
                                KFImage(URL(string: homeViewModel.selectedMembers[index].image!)!)
                                    .resizable()
                                    .placeholder {
                                        Image("Profile")
                                            .resizable()
                                            .frame(width: 45, height: 45)
                                    }
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(.whereDeepPink, lineWidth: homeViewModel.selectedMembers[index].inCluster == true ? 3 : 0))
                                    .overlay(Circle().stroke(.black, lineWidth: homeViewModel.selectedMembers[index].inCluster == false ? 0.1 : 0))
                                    .frame(width: 45, height: 45)
                                    .padding(5)
                            }

                            VStack {
                                HStack {
                                    Spacer()

                                    Button {
                                        if let removeIndex = homeViewModel.selectedMembers.firstIndex(
                                            where: { $0.intraId == homeViewModel.selectedMembers[index].intraId })
                                        {
                                            withAnimation {
                                                if let searchIndex = searchViewModel.searching.firstIndex(where: {
                                                    $0.intraId == homeViewModel.selectedMembers[index].intraId
                                                }) {
                                                    searchViewModel.searching[searchIndex].isCheck = false
                                                }
                                                _ = homeViewModel.selectedMembers.remove(at: removeIndex)
                                            }
                                        }
                                    } label: {
                                        Image("Cross icon")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                    }
                                }
                                Spacer()
                            }
                            .frame(width: 45, height: 45)
                        }

                        Text(homeViewModel.selectedMembers[index].intraName!)
                            .font(.custom(Font.GmarketMedium, size: 11))
                            .foregroundStyle(.whereDeepNavy)
                            .padding(.bottom, 2)
                    }
                }
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 0)
    }
}

#Preview {
    SearchSelectedMembersView()
        .environmentObject(HomeViewModel())
}

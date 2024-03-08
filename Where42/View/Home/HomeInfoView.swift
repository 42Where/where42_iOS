//
//  HomeInfoView.swift
//  Where42
//
//  Created by 현동호 on 11/7/23.
//

import Kingfisher
import SwiftUI

struct HomeInfoView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel
    
    @Binding var memberInfo: MemberInfo
    @Binding var isWork: Bool
    @Binding var isNewGroupAlertPrsented: Bool

    var body: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: memberInfo.image!)!)
                .resizable()
                .placeholder {
                    Image("Profile")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                .clipShape(Circle())
                .overlay(Circle().stroke(.whereDeepPink, lineWidth: memberInfo.inCluster == true ? 3 : 0))
                .overlay(Circle().stroke(.black, lineWidth: memberInfo.inCluster == false ? 0.1 : 0))
                .frame(width: 80, height: 80)
                
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(memberInfo.intraName!)
                        .font(.custom(Font.GmarketBold, size: 20))
                        .foregroundStyle(.whereDeepNavy)
                        
                    Button {
                        if homeViewModel.myInfo.inCluster == true {
                            withAnimation {
                                settingViewModel.isCustomLocationAlertPresented = true
                            }
                        } else {
                            mainViewModel.toast = Toast(title: "자리 설정은 클러스터 안에서만 할 수 있습니다")
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(memberInfo.getLocation())
                                
                            if memberInfo.inCluster == true {
                                Image("Search icon White M")
                                    .resizable()
                                    .frame(width: 18, height: 18)
                            }
                        }
                        .font(.custom(Font.GmarketMedium, size: 15))
                        .padding(5.0)
                        .padding(.horizontal, 2.0)
                        .background(memberInfo.inCluster == true ? .whereDeepNavy : .white)
                        .clipShape(Capsule())
                        .overlay(memberInfo.inCluster == true ? Capsule().stroke(.whereDeepNavy, lineWidth: 0) : Capsule().stroke(.whereDeepNavy, lineWidth: 1))
                        .foregroundStyle(memberInfo.inCluster == true ? .white : .whereDeepNavy)
                    }
                }
                    
                Text(memberInfo.comment!)
                    .font(.custom(Font.GmarketMedium, size: 16))
                    .foregroundStyle(.whereMediumNavy)
                    .lineLimit(1)

                HStack {
                    Spacer()
                        
                    Button {
                        withAnimation {
                            isNewGroupAlertPrsented = true
                        }
                        homeViewModel.selectedMembers = []
                    } label: {
                        Image("Group icon")
                        Text("새 그룹")
                    }
                    .padding(5.0)
                    .padding(.horizontal, 2.0)
                    .overlay(Capsule().stroke(.whereDeepNavy, lineWidth: 1))
                    
                    Button {
                        withAnimation {
                            isWork.toggle()
                        }
                    } label: {
                        if isWork {
                            Image("Checked Box")
                        } else {
                            Image("Empty Box")
                        }
                        Text("출근한 친구만 보기")
                    }
                    .padding(5.0)
                    .padding(.horizontal, 2.0)
                    .overlay(Capsule().stroke(.whereDeepNavy, lineWidth: 1))
                }
                .font(.custom(Font.GmarketMedium, size: 13))
                .foregroundStyle(.whereDeepNavy)
                .unredacted()
            }
                
            Spacer()
        }
        .padding([.top, .leading])
    }
}

#Preview {
    HomeInfoView(memberInfo: .constant(MemberInfo(intraName: "dhyun", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요", location: "개포 c2r5s6")), isWork: .constant(false), isNewGroupAlertPrsented: .constant(false))
}

//            AsyncImage(url: URL(string: userInfo.avatar)) { image in
//                VStack {
//                    image
//                        .resizable()
//                        .clipShape(Circle())
//                        .overlay(Circle().stroke(.whereDeepPink, lineWidth: userInfo.location != "퇴근" ? 3 : 0))
//                }
//            } placeholder: {
//                Image("Profile")
//                    .resizable()
//                ProgressView()
//            }
//            .frame(width: 80, height: 80)

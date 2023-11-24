//
//  HomeInfoView.swift
//  Where42
//
//  Created by 현동호 on 11/7/23.
//

import Kingfisher
import SwiftUI

struct HomeInfoView: View {
    @Binding var userInfo: UserInfo
    @Binding var isWork: Bool
    @Binding var isNewGroupAlertPrsent: Bool

    var body: some View {
        HStack(spacing: 10) {
            KFImage(URL(string: userInfo.avatar)!)
                .resizable()
                .placeholder {
                    Image("Profile")
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                .clipShape(Circle())
                .overlay(Circle().stroke(.whereDeepPink, lineWidth: userInfo.location != "퇴근" ? 3 : 0))
                .frame(width: 80, height: 80)
                
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    Text(userInfo.name)
                        .font(.custom(Font.GmarketBold, size: 20))
                        .foregroundStyle(.whereDeepNavy)
                        
                    HStack(spacing: 4) {
                        Text(userInfo.location)
                        if userInfo.location != "퇴근" {
                            Image("Search icon White M")
                                .resizable()
                                .frame(width: 18, height: 18)
                        }
                    }
                    .font(.custom(Font.GmarketMedium, size: 15))
                    .padding(5.0)
                    .padding(.horizontal, 2.0)
                    .background(userInfo.location == "퇴근" ? .white : .whereDeepNavy)
                    .clipShape(Capsule())
                    .overlay(userInfo.location == "퇴근" ? Capsule().stroke(.whereDeepNavy, lineWidth: 1) : Capsule().stroke(.whereDeepNavy, lineWidth: 0))
                    .foregroundStyle(userInfo.location == "퇴근" ? .whereDeepNavy : .white)
                }
                    
                Text(userInfo.comment)
                    .font(.custom(Font.GmarketMedium, size: 16))
                    .foregroundStyle(.whereMediumNavy)
                    
                HStack {
                    Spacer()
                        
                    Button {
                        withAnimation {
                            isNewGroupAlertPrsent.toggle()
                        }
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
            }
                
            Spacer()
        }
        .padding([.top, .leading])
    }
}

#Preview {
    HomeInfoView(userInfo: .constant(UserInfo(name: "dhyun", avatar: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", location: "개포 c2r5s6", comment: "안녕하세요")), isWork: .constant(false), isNewGroupAlertPrsent: .constant(false))
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

//
//  GroupMemeberAddView.swift
//  Where42
//
//  Created by 현동호 on 1/20/24.
//

import SwiftUI

struct GroupMemberAddView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel

    @Binding var group: GroupInfo
    @Binding var isGroupEditModalPresented: Bool

    @State private var isShowSheet = false
    @State private var name = ""

    var body: some View {
        VStack {
            Text("\(homeViewModel.selectedGroup.groupName)")
                .font(.custom(Font.GmarketBold, size: 25))
                .padding(.top, 40)
            
            HStack {
                Image("Search icon M")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 20)
                TextField("이름을 입력해주세요", text: $name)
                    .textInputAutocapitalization(.never)
                    .autocorrectionDisabled()
                
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
            .padding([.horizontal, .top])
            
            if group.members.count == 0 || (name != "" && homeViewModel.viewPresentCount == 0) {
                Spacer()
                
                VStack {
                    VStack {
                        if group.members.count == 0 {
                            Text("추가할 수 있는 멤버가 없습니다")
                        } else {
                            Text("존재하지 않는 멤버입니다")
                        }
                    }
                    .font(.custom(Font.GmarketBold, size: 20))
                    .foregroundStyle(.whereDeepNavy)
                }
                
                Spacer()
            } else {
                ScrollView {
                    LazyVStack {
                        ForEach(0 ..< group.members.count, id: \.self) { index in
                            if group.members[index].isCheck == true ||
                                name == "" ||
                                (group.members[index].intraName?.contains(name.lowercased())) == true
                            {
                                if UIDevice.idiom == .phone {
                                    SelectingFriendInfoView(userInfo: $group.members[index])
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
                                            SelectingFriendInfoView(userInfo: $group.members[index])
                                                .padding([.top, .leading, .trailing])
                                                .onAppear {
                                                    homeViewModel.viewPresentCount += 1
                                                }
                                                .onDisappear {
                                                    homeViewModel.viewPresentCount -= 1
                                                }
                                            if index + 1 < group.members.count {
                                                SelectingFriendInfoView(userInfo: $group.members[index + 1])
                                                    .padding([.top, .leading, .trailing])
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
                        
                        Spacer()
                    }
                    .padding([.horizontal, .bottom])
                    .onAppear {
                        homeViewModel.viewPresentCount = 0
                    }
                }
            }
                
            HStack {
                Spacer()
                    
                Button {
                    Task {
                        if homeViewModel.selectedUsers.isEmpty == false {
                            await homeViewModel.addMemberInGroup(
                                groupId: homeViewModel.selectedGroup.groupId!
                            )
                        }
                    }
                    withAnimation {
                        isGroupEditModalPresented = false
                        homeViewModel.isGroupMemberAddViewPrsented = false
                    }
                } label: {
                    HStack {
                        Text("멤버 추가하기")
                            .font(.custom(Font.GmarketMedium, size: 20))
                            .foregroundStyle(.white)
                    }
                }
                .clipShape(Rectangle())
                .padding()
                    
                Spacer()
            }
            .background(.whereDeepNavy)
            .disabled(group.members.count == 0)
        }
        
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    GroupMemberAddView(group: .constant(GroupInfo(id: UUID(), groupId: 0, groupName: "테스트 그룹", totalNum: 10, onlineNum: 10, isOpen: true, members: [
        .init(intraName: "dhyun1", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun2", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "퇴근"),
        .init(intraName: "dhyun3", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun4", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun5", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun6", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun7", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun8", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun9", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun10", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun11", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun12", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun13", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun14", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun15", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun16", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun17", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun18", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun19", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun20", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun21", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun22", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6"),
        .init(intraName: "dhyun23", image: "https://cdn.intra.42.fr/users/16be1203bb548bd66ed209191ff6d30d/dhyun.jpg", comment: "안녕하세요~", location: "개포 c2r5s6")
    ])), isGroupEditModalPresented: .constant(true))
        .environmentObject(HomeViewModel())
}

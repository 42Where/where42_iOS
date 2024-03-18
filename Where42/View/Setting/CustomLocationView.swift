//
//  CustomLocationView.swift
//  Where42
//
//  Created by 현동호 on 1/20/24.
//

import SwiftUI

struct CustomLocationView: View {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        settingViewModel.isCustomLocationAlertPresented = false
                        settingViewModel.initCustomLocation()
                    }
                }

            VStack {
                Text("수동 자리 설정")
                    .font(.custom(Font.GmarketBold, size: 18))
                    .padding(.bottom, 10)

                VStack {
                    HStack(alignment: .top, spacing: 0) {
                        VStack(spacing: 10) {
                            Text("층")
                                .font(.custom(Font.GmarketBold, size: 18))

                            Divider()
                                .overlay(.whereDeepNavy)

                            VStack(spacing: 0) {
                                ForEach(settingViewModel.defaultFloor.indices, id: \.self) { index in
                                    Button {
                                        settingViewModel.selectedFloor = index
                                        settingViewModel.customLocation = settingViewModel.defaultFloor[index]
                                        settingViewModel.selectedLocation = ""
                                    } label: {
                                        Group {
                                            if settingViewModel.selectedFloor == index {
                                                ZStack {
                                                    Text(settingViewModel.defaultFloor[index])

                                                    HStack {
                                                        Spacer()

                                                        if index != 0 {
                                                            Image("Next icon")
                                                                .padding(.trailing, 5)
                                                        }
                                                    }
                                                }
                                                .frame(width: UIDevice.idiom == .phone ? 135 : 175, height: 22)
                                                .background(.black.opacity(0.12))
                                                .clipShape(RoundedRectangle(cornerRadius: 3.0))

                                            } else {
                                                Text(settingViewModel.defaultFloor[index])
                                                    .frame(width: UIDevice.idiom == .phone ? 135 : 175, height: 22)
                                            }
                                        }
                                        .padding(.bottom, index != 6 ? 13 : 0)
                                    }
                                }
                            }
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .foregroundStyle(.whereDeepNavy)
                        }
                        .frame(width: UIDevice.idiom == .phone ? 140 : 180)
                        .padding(.vertical, 15)

                        Divider()
                            .overlay(.whereDeepNavy)

                        VStack(spacing: 10) {
                            Text("자리")
                                .font(.custom(Font.GmarketBold, size: 18))

                            Divider()
                                .overlay(.whereDeepNavy)

                            VStack(spacing: 0) {
                                ForEach(settingViewModel.defaultLocation[settingViewModel.selectedFloor], id: \.self) { location in
                                    Button {
                                        settingViewModel.setCustomLocation()
                                        settingViewModel.selectedLocation = location
                                    } label: {
                                        Group {
                                            if location != settingViewModel.selectedLocation {
                                                Text(location)
                                                    .frame(width: UIDevice.idiom == .phone ? 135 : 175, height: 22)
                                            } else {
                                                Text(location)
                                                    .frame(width: UIDevice.idiom == .phone ? 135 : 175, height: 22)
                                                    .background(.black.opacity(0.12))
                                                    .clipShape(RoundedRectangle(cornerRadius: 3.0))
                                            }
                                        }
                                        .padding(.bottom, location != settingViewModel.defaultLocation[settingViewModel.selectedFloor].last ? 13 : 0)
                                    }
                                }
                            }
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .foregroundStyle(.whereDeepNavy)
                        }
                        .frame(width: UIDevice.idiom == .phone ? 140 : 180)
                        .padding(.vertical, 15)
                    }
                }
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.whereDeepNavy, lineWidth: 1)
                )

                HStack {
                    Spacer()

                    Button {
                        withAnimation {
                            settingViewModel.isInitCustomLocationAlertPrsented = true
                        }
                    } label: {
                        Text("초기화")
                            .padding(.horizontal, 4)
                            .padding(4)
                            .foregroundStyle(.red)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.red, lineWidth: 1)
                            )
                    }

                    Button {
                        withAnimation {
                            settingViewModel.isCustomLocationAlertPresented = false
                            settingViewModel.initCustomLocation()
                        }
                    } label: {
                        Text("취소")
                            .padding(.horizontal, 6)
                            .padding(4)
                            .foregroundStyle(.whereDeepNavy)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(.whereDeepNavy, lineWidth: 1)
                            )
                    }

                    Button {
                        Task {
                            let status = await settingViewModel.UpdateCustomLocation()

                            if status == nil {
                                withAnimation {
                                    self.homeViewModel.myInfo.location = self.settingViewModel.newLocation
                                }
                            } else {
                                mainViewModel.setToast(type: status)
                            }
                        }
                    } label: {
                        Text("확인")
                            .padding(.horizontal, 6)
                            .padding(4.5)
                            .foregroundStyle(.white)
                            .background(.whereDeepNavy)
                            .clipShape(
                                RoundedRectangle(cornerRadius: 10)
                            )
                    }
                }
                .font(.custom(Font.GmarketMedium, size: 15))
                .padding(.trailing, 10)
            }
//            .frame(width: 300, height: 367)
            .frame(width: UIDevice.idiom == .phone ? 300 : 380, height: 367)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
        .onAppear {
            settingViewModel.customLocation = "지하"
        }

        if settingViewModel.isInitCustomLocationAlertPrsented {
            CustomAlert(
                title: "자리 설정 초기화",
                message: "수동 자리 설정을 초기화하시겠습니까?",
                inputText: .constant("")
            ) {
                withAnimation {
                    settingViewModel.isInitCustomLocationAlertPrsented = false
                }
            } rightButtonAction: {
                let status = await settingViewModel.resetCustomLocation()

                if status == nil {
                    withAnimation {
                        self.homeViewModel.myInfo.location = self.settingViewModel.newLocation
                    }
                } else {
                    mainViewModel.setToast(type: status)
                }
            }
        }
    }
}

#Preview {
    CustomLocationView()
        .environmentObject(HomeViewModel())
        .environmentObject(MainViewModel())
        .environmentObject(SettingViewModel())
}

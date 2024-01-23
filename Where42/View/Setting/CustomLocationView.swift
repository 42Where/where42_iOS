//
//  CustomLocationView.swift
//  Where42
//
//  Created by 현동호 on 1/20/24.
//

import SwiftUI

struct CustomLocationView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var settingViewModel: SettingViewModel

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.3)
                .ignoresSafeArea(.all)
                .onTapGesture {
                    withAnimation {
                        settingViewModel.isCustomLocationAlertPresent = false
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
                                    if index != 0 {
                                        Button {
                                            settingViewModel.selectedFloor = index
                                        } label: {
                                            if settingViewModel.selectedFloor == index {
                                                ZStack {
                                                    Text(settingViewModel.defaultFloor[index])

                                                    HStack {
                                                        Spacer()

                                                        Image("Next icon")
                                                            .padding(.trailing, 5)
                                                    }
                                                }
                                                .frame(width: 135, height: 22)
                                                .background(.black.opacity(0.12))
                                                .clipShape(RoundedRectangle(cornerRadius: 3.0))
                                                .padding(.bottom, 13)
                                            } else {
                                                Text(settingViewModel.defaultFloor[index])
                                                    .frame(width: 135, height: 22)
                                                    .padding(.bottom, 13)
                                            }
                                        }
                                    }
                                }
                            }
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .foregroundStyle(.whereDeepNavy)
                        }
                        .frame(width: 140)
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
                                        settingViewModel.setCustomLocation(location: location)
                                        settingViewModel.selectedLocation = location
                                    } label: {
                                        if location != settingViewModel.selectedLocation {
                                            Text(location)
                                                .frame(width: 135, height: 22)
                                                .padding(.bottom, 13)
                                        } else {
                                            Text(location)
                                                .frame(width: 135, height: 22)
                                                .background(.black.opacity(0.12))
                                                .clipShape(RoundedRectangle(cornerRadius: 3.0))
                                                .padding(.bottom, 13)
                                        }
                                    }
                                }
                            }
                            .font(.custom(Font.GmarketMedium, size: 15))
                            .foregroundStyle(.whereDeepNavy)
                        }
                        .frame(width: 140)
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
                            settingViewModel.isCustomLocationAlertPresent = false
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
                            await settingViewModel.UpdateCustomLocation()
                            homeViewModel.myInfo.location = settingViewModel.newLocation
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
            .frame(width: 300, height: 350)
            .padding()
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 15))
        }
    }
}

#Preview {
    CustomLocationView()
        .environmentObject(SettingViewModel())
}

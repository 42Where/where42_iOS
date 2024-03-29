//
//  LoginView.swift
//  Where42
//
//  Created by 현동호 on 10/30/23.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    var body: some View {
        ZStack {
            VStack {
                Text(networkMonitor.ㅁㅁㅁ).font(.headline).zIndex(10)
                Spacer()

                ZStack {
                    VStack {
                        Spacer()

                        RoundedRectangle(cornerRadius: 150.0)
                            .frame(width: UIScreen.main.bounds.width * 1.7, height: UIScreen.main.bounds.height * 3.46 / 9)
                    }
                    VStack {
                        Spacer()

                        Rectangle()
                            .frame(width: UIScreen.main.bounds.width * 1.7, height: UIScreen.main.bounds.height * 1 / 9)
                    }
                }
                .frame(maxWidth: UIScreen.main.bounds.width)
            }
            .ignoresSafeArea(edges: .bottom)

            VStack(spacing: 10) {
                Spacer()
                Spacer()

                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 110)

                Spacer()

                Text("42서울 위치 정보 검색 서비스")
                    .font(.custom("GmarketSansTTFLight", size: 16))

                Text("어디 있니?")
                    .font(.custom("GmarketSansTTFBold", size: 35.0))

                Spacer()

                Button {
                    API.sharedAPI.accessToken = ""
                    loginViewModel.isLoginButtonPushed = true
                    loginViewModel.timer = loginViewModel.timer.upstream.autoconnect()
                    loginViewModel.login()
                } label: {
                    Text("L O G I N" + loginViewModel.dots)
                }
                .font(.custom("GmarketSansTTFBold", size: 20.0))
                .foregroundStyle(.white)
                .padding(.vertical)
                .frame(width: 200, height: 80)
                .background(Capsule().fill(.whereMediumNavy))
//                .background(Capsule().fill(.whereDeepNavy))
                .padding(.bottom, 120.0)

                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                VStack {
                    Button {
                        withAnimation {
                            loginViewModel.isHelpPagePresented.toggle()
                        }
                    } label: {
                        Image("Wiki icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                    }
                    .sheet(isPresented: $loginViewModel.isHelpPagePresented, content: {
                        HelpPage()
                    })

                    Spacer()
                }
            }

            if loginViewModel.isShowAgreementSheet {
                PersonalInfoAgreementView(
                    isPresent: $loginViewModel.isShowAgreementSheet
                )
                .zIndex(1)
            }
        }
        .onAppear {
            MainViewModel.shared.toast = nil
            loginViewModel.timer.upstream.connect().cancel()
        }
        .onReceive(loginViewModel.timer) { _ in
            if loginViewModel.isLoginButtonPushed {
                if loginViewModel.dots != " . . ." {
                    loginViewModel.dots += " ."
                } else {
                    loginViewModel.dots = " ."
                }
            }
        }
        .disabled(loginViewModel.isLoginButtonPushed)
        .foregroundColor(.whereDeepNavy)
        .environmentObject(loginViewModel)
    }
}

#Preview("iPhone 15 Pro") {
    LoginView()
        .environmentObject(HomeViewModel())
        .environmentObject(LoginViewModel())
}

// struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//            .previewDevice(PreviewDevice(rawValue: DeviceName.iPhone_SE_3rd_generation.rawValue))
//            .previewDisplayName("iPhone SE 3rd")
//    }
// }

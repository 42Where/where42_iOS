//
//  LoginView.swift
//  Where42
//
//  Created by 현동호 on 10/30/23.
//

import SwiftUI

struct LoginView: View {
    @StateObject var loginViewModel: LoginViewModel = .init()

    @AppStorage("isLogin") var isLogin: Bool = false
    @AppStorage("isLoginViewPresented") var isLoginViewPresented: Bool = true

    var body: some View {
        ZStack {
            VStack {
                Spacer()

                ZStack {
                    VStack {
                        Spacer()

                        RoundedRectangle(cornerRadius: 150.0)
                            .frame(width: UIScreen.main.bounds.width * 1.7, height: UIScreen.main.bounds.height * 3.7 / 9)
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

                Button("L O G I N") {
                    isLogin.toggle()
                    isLoginViewPresented.toggle()
                }
                .font(.custom("GmarketSansTTFBold", size: 20.0))
                .foregroundStyle(.white)
                .padding(.vertical)
                .frame(width: 200, height: 80)
                .background(Capsule().fill(.whereMediumNavy))
                .padding(.bottom, 120.0)

                Spacer()
            }

            Spacer()

            HStack {
                Spacer()
                VStack {
                    Button {
                        withAnimation {
                            loginViewModel.isHelpPagePresent.toggle()
                        }
                    } label: {
                        Image("Wiki icon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 50)
                    }
                    .sheet(isPresented: $loginViewModel.isHelpPagePresent, content: {
                        HelpPage()
                    })

                    Spacer()
                }
            }
        }
        .foregroundColor(.whereDeepNavy)
    }
}

#Preview("iPhone 15 Pro") {
    Group {
        LoginView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .previewDevice(PreviewDevice(rawValue: DeviceName.iPhone_SE_3rd_generation.rawValue))
            .previewDisplayName("iPhone SE 3rd")
    }
}

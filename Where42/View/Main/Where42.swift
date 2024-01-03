//
//  ContentView.swift
//  Where42
//
//  Created by 현동호 on 10/27/23.
//

import Kingfisher
import SwiftUI

struct Where42: View {
    init() {
        UITabBar.appearance().scrollEdgeAppearance = .init()
    }

    @StateObject var mainViewModel: MainViewModel = .init()
    @StateObject var homeViewModel: HomeViewModel = .init()

    @AppStorage("isLogin") var isLogin: Bool = false

    @Environment(\.horizontalSizeClass) var oldSizeClass

    var body: some View {
        ZStack {
            if isLogin {
                VStack {
                    TabView(selection: $mainViewModel.tabSelection) {
                        HomeView()
                            .tabItem {
                                Image("Home icon M")
                                Text("⸻")
                            }
                            .tag("Home")
                            .environment(\.horizontalSizeClass, oldSizeClass)

                        SearchView()
                            .tabItem {
                                VStack {
                                    Image("Search icon M")
                                    Text("⸻")
                                }
                            }
                            .tag("Search")
                            .environment(\.horizontalSizeClass, oldSizeClass)
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.yellow, for: .tabBar)
                    .environment(\.horizontalSizeClass, .compact)
                }
                .zIndex(0)
                .fullScreenCover(isPresented: $mainViewModel.isSelectViewPrsented) {
                    SelectingView()
                }

                MainAlertView()
                    .zIndex(1)

                if mainViewModel.isPersonalViewPrsented {
                    PersonalInfoAgreementView()
                }

            } else {
                VStack {
                    LoginView()
                }
                .transition(.asymmetric(insertion: AnyTransition.move(edge: .bottom),
                                        removal: AnyTransition.move(edge: .bottom)))
            }
        }
//        .fullScreenCover(isPresented: $homeViewModel.isShow42IntraSheet) {
//            MyWebView(url: homeViewModel.intraURL!)
//                .ignoresSafeArea()
//        }
        .animation(.easeIn, value: isLogin)
        .environmentObject(mainViewModel)
        .environmentObject(homeViewModel)
    }
}

#Preview {
    Where42()
        .environmentObject(MainViewModel())
        .environmentObject(HomeViewModel())
}

// struct Previews: PreviewProvider {
//    static var previews: some View {
//        Where42()
//            .previewDevice(PreviewDevice(rawValue: DeviceName.iPhone_SE_3rd_generation.rawValue))
//            .previewDisplayName("iPhone SE 3rd")
//            .environmentObject(MainViewModel())
//            .environmentObject(HomeViewModel())
//    }
// }

// struct Previews2: PreviewProvider {
//    static var previews: some View {
//        Where42()
//            .previewDevice(PreviewDevice(rawValue: DeviceName.iPad_Air_5th_generation.rawValue))
//            .previewDisplayName("iPad Air 5th")
//            .environmentObject(MainViewModel())
//            .environmentObject(HomeViewModel())
//    }
// }

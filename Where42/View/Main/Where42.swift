//
//  ContentView.swift
//  Where42
//
//  Created by 현동호 on 10/27/23.
//

import SwiftUI

struct Where42: View {
    init() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .bold)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 40, weight: .bold)], for: .selected)
        UITabBar.appearance().scrollEdgeAppearance = .init()
    }

    @StateObject var mainViewModel: MainViewModel = .init()
    @StateObject var homeViewModel: HomeViewModel = .init()

    @AppStorage("isLogin") var isLogin: Bool = false

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

                        SearchView()
                            .tabItem {
                                Image("Search icon M")
                                Text("⸻")
                            }
                            .tag("Search")
                    }
                    .toolbar(.visible, for: .tabBar)
                    .toolbarBackground(Color.yellow, for: .tabBar)

                    .onAppear(perform: {
//                        UITabBar.appearance().scrollEdgeAppearance = .init()
                    })
                }
                .fullScreenCover(isPresented: $mainViewModel.isSelectViewPrsented) {
                    SelectingView()
                }

                MainAlertView()

            } else {
                VStack {
                    LoginView()
                }
                .transition(.asymmetric(insertion: AnyTransition.move(edge: .bottom),
                                        removal: AnyTransition.move(edge: .bottom)))
            }
        }
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

 struct Previews2: PreviewProvider {
    static var previews: some View {
        Where42()
            .previewDevice(PreviewDevice(rawValue: DeviceName.iPad_Air_5th_generation.rawValue))
            .previewDisplayName("iPad Air 5th")
            .environmentObject(MainViewModel())
            .environmentObject(HomeViewModel())
    }
 }

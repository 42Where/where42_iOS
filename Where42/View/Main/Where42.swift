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
    @StateObject var networkMonitor: NetworkMonitor = .init()

    @AppStorage("isLogin") var isLogin: Bool = false

    @Environment(\.horizontalSizeClass) var oldSizeClass

    var body: some View {
        NavigationView {
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
                        .environment(\.horizontalSizeClass, .compact)
                    }
                    .fullScreenCover(isPresented: $mainViewModel.isSelectViewPrsented) {
                        SelectingView()
                    }
                    .toolbar {
                        Where42ToolBarContent(
                            isShowSheet: $homeViewModel.isShowSettingSheet
                        )
                    }
                    .unredacted()
                    .zIndex(0)

                    MainAlertView()
                        .zIndex(1)

                } else {
                    VStack {
                        LoginView()
                    }
                    .transition(
                        .asymmetric(
                            insertion: AnyTransition.move(edge: .bottom),
                            removal: AnyTransition.move(edge: .bottom)
                        ))
                }

                if networkMonitor.isConnected == false {
                    NetworkMonitorView()
                }
            }
            .fullScreenCover(isPresented: $homeViewModel.isShow42IntraSheet) {
                MyWebView(
                    urlToLoad: homeViewModel.intraURL!,
                    isPresented: $homeViewModel.isShow42IntraSheet
                )
                .ignoresSafeArea()
            }
            .toastView(toast: $mainViewModel.toast)
        }

        .navigationViewStyle(StackNavigationViewStyle())

        .animation(.easeIn, value: isLogin)
        .environmentObject(mainViewModel)
        .environmentObject(homeViewModel)
        .environmentObject(networkMonitor)
    }
}

#Preview {
    Where42()
        .environmentObject(MainViewModel())
        .environmentObject(HomeViewModel())
}

// struct Previews2: PreviewProvider {
//    static var previews: some View {
//        Where42()
//            .previewDevice(PreviewDevice(rawValue: DeviceName.iPad_Air_5th_generation.rawValue))
//            .previewDisplayName("iPad Air 5th")
//            .environmentObject(MainViewModel())
//            .environmentObject(HomeViewModel())
//    }
// }

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

    @EnvironmentObject private var sceneDelegate: WhereSceneDelegate
    @StateObject var mainViewModel: MainViewModel = .shared
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
                    .toolbar {
                        Where42ToolBarContent(
                            //                            isShowSheet: $homeViewModel.isShowSettingSheet
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

                if homeViewModel.isShow42IntraSheet == true && homeViewModel.isLogout == false && networkMonitor.isConnected == true {
                    MyWebView(
                        urlToLoad: homeViewModel.intraURL!,
                        isPresented: $homeViewModel.isShow42IntraSheet
                    )
                    .ignoresSafeArea()
                    .zIndex(-1)
                    ProgressView()
                        .zIndex(2)
                }
            }
            .fullScreenCover(isPresented: homeViewModel.isLogout == true ? $homeViewModel.isShow42IntraSheet : .constant(false)) {
                MyWebView(
                    urlToLoad: homeViewModel.intraURL!,
                    isPresented: $homeViewModel.isShow42IntraSheet
                )
                .ignoresSafeArea()
            }

            .disabled(homeViewModel.isShow42IntraSheet && networkMonitor.isConnected)
        }
        .onChange(of: homeViewModel.toast) { newToast in
            if newToast != nil {
                mainViewModel.toast = newToast
                homeViewModel.toast = nil
            }
        }
        .onChange(of: mainViewModel.toast) { newToast in
            sceneDelegate.toastState = newToast
        }
        .toastView(toast: $mainViewModel.toast)

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
        .environmentObject(API())
        .environmentObject(WhereSceneDelegate())
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

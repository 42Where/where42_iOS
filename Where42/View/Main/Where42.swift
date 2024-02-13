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

                    if mainViewModel.is42IntraSheetPresented == true && mainViewModel.isLogout == false && networkMonitor.isConnected == true {
                        MyWebView(
                            urlToLoad: mainViewModel.intraURL,
                            isPresented: $mainViewModel.is42IntraSheetPresented
                        )
                        .ignoresSafeArea()
                        .zIndex(-1)
                        ProgressView()
                            .zIndex(2)
                    }
                }
                .disabled(mainViewModel.is42IntraSheetPresented && networkMonitor.isConnected)
            }
            .fullScreenCover(isPresented: mainViewModel.isLogout == true && networkMonitor.isConnected == true ? $mainViewModel.is42IntraSheetPresented : .constant(false)) {
                MyWebView(
                    urlToLoad: mainViewModel.intraURL,
                    isPresented: $mainViewModel.is42IntraSheetPresented
                )
                .ignoresSafeArea()
            }
        }
        .onAppear {
            sceneDelegate.toastState = mainViewModel.toast
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
        .environmentObject(NetworkMonitor())
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

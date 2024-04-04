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
    @StateObject var loginViewModel: LoginViewModel = .init()
    @StateObject var settingViewModel: SettingViewModel = .init()
    @StateObject var networkMonitor: NetworkMonitor = .shared

    @Environment(\.horizontalSizeClass) var oldSizeClass

    var body: some View {
        NavigationView {
            ZStack {
                ZStack {
                    if mainViewModel.isLogin {
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
                            Where42ToolBarContent()
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

                    if mainViewModel.is42IntraSheetPresented == true &&
                        networkMonitor.isConnected == true
                    {
                        MyWebView(
                            urlToLoad: mainViewModel.intraURL,
                            isPresented: $mainViewModel.is42IntraSheetPresented
                        )
                        .ignoresSafeArea()
                        .zIndex(-1)
                        ProgressView()
                            .scaleEffect(2)
                            .progressViewStyle(.circular)
                            .zIndex(2)
                    }
                }
                .disabled(mainViewModel.is42IntraSheetPresented && networkMonitor.isConnected)
            }
            .fullScreenCover(isPresented: networkMonitor.isConnected == true ? $mainViewModel.is42IntraSheetPresented : .constant(false)) {
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
        .navigationBarTitleDisplayMode(.inline)

        .animation(.easeIn, value: mainViewModel.isLogin)

        .environmentObject(mainViewModel)
        .environmentObject(homeViewModel)
        .environmentObject(loginViewModel)
        .environmentObject(settingViewModel)
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

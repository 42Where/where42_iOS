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
    @State private var isStatViewLoaded: Bool = false

    @Environment(\.horizontalSizeClass) var oldSizeClass

    var body: some View {
        NavigationView {
            ZStack {
                if mainViewModel.isLogin {
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
                        
                        StatView()
                            .tabItem {
                                VStack {
                                    Image("Stat icon M")
                                    Text("⸻")
                                }
                            }
                            .onAppear() {
                                isStatViewLoaded = true
                            }
                            .onDisappear() {
                                isStatViewLoaded = false
                            }
                            .tag("Stat")
                            .environment(\.horizontalSizeClass, oldSizeClass)
                    }
                    .environment(\.horizontalSizeClass, .compact)
                    .toolbar {
                        Where42ToolBarContent()
                    }
                    .toolbarBackground(isStatViewLoaded ? .visible : .hidden, for: .navigationBar)
                    .unredacted()
                    .zIndex(0)

                    MainAlertView()
                        .zIndex(1)

                }
                else {
                    LoginView()
                        .transition(
                            .asymmetric(
                                insertion: AnyTransition.move(edge: .bottom),
                                removal: AnyTransition.move(edge: .bottom)
                            ))
                }

                if homeViewModel.isLoading == false && networkMonitor.isConnected == false {
                    NetworkMonitorView()
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

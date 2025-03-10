//
//  MyWebView.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI
import WebKit

class FullScreenWKWebView: WKWebView {
    var accessoryView: UIView?
    
    override var inputAccessoryView: UIView? {
        return accessoryView
    } // accessoryView 지우기
    
    override var safeAreaInsets: UIEdgeInsets {
        let window = UIApplication.shared.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .map { $0 as? UIWindowScene }
            .compactMap { $0 }
            .first?.windows
            .filter { $0.isKeyWindow }.first

        return UIEdgeInsets(top: window?.safeAreaInsets.top ?? 0, left: 0, bottom: 0, right: 0)
    } // safeArea 까지 출력
}

struct MyWebView: UIViewRepresentable {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var loginViewModel: LoginViewModel
    
    var urlToLoad: String
    
    @Binding var isPresented: Bool
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: urlToLoad) else {
            return FullScreenWKWebView()
        }
        
        DispatchQueue.main.async {
            self.homeViewModel.isAPILoaded = false
        }
        
        let webSiteDataTypes = NSSet(array: [WKWebsiteDataTypeCookies])
        let date = NSDate(timeIntervalSince1970: 0)
        WKWebsiteDataStore.default().removeData(ofTypes: webSiteDataTypes as! Set, modifiedSince: date as Date, completionHandler: {})
        
        // viewport 설정을 통해 사용자가 페이지 확대 축소를 못하도록 고정
        let source = "var meta = document.createElement('meta');" +
            "meta.name = 'viewport';" +
            "meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';" +
            "var head = document.getElementsByTagName('head')[0];" +
            "head.appendChild(meta);"

        let script = WKUserScript(source: source, injectionTime: .atDocumentEnd, forMainFrameOnly: true)
        let userContentController = WKUserContentController()
        let conf = WKWebViewConfiguration()
        conf.userContentController = userContentController
        userContentController.addUserScript(script)
        let webView = FullScreenWKWebView(frame: CGRect.zero, configuration: conf)
        
        webView.navigationDelegate = context.coordinator
        webView.scrollView.isScrollEnabled = false
        webView.load(URLRequest(url: url))
        
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: MyWebView
        
        init(_ parent: MyWebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
            if let redirectURL = webView.url?.absoluteString {
//                print(redirectURL)
                if redirectURL == "https://profile.intra.42.fr" {
                    printError(message: "reached intra profile")
                    return
                }
                if redirectURL.contains("https://where42.kr/") == true {
                    if redirectURL.contains("login-fail") == true {
                        printError(message: "reached login-fail")
                        return
                    } else if redirectURL.contains("?intraId=") == true {
                        if let url = URL(string: redirectURL),
                           let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
                           let queryItems = components.queryItems {
                            if let intraIdStr = queryItems.first(where: { $0.name == "intraId" })?.value {
                                KeychainManager.createToken(key: "intraId", token: intraIdStr)
                            } else {
                                print("intraId가 존재하지 않습니다.")
                            }
                        } else {
                            print("URL을 파싱할 수 없습니다.")
                        }
                        let query = webView.url?.query()?.split(separator: "&")
                        webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
//                                print("-------------- Cookie --------------")
                            for cookie in cookies {
//                                    print("[" + cookie.name + "]", cookie.value)
                                if cookie.name == "accessToken" {
                                    KeychainManager.createToken(key: "accessToken", token: "Bearer " + cookie.value)
                                    HTTPCookieStorage.shared.setCookie(cookie)
                                }
//                                else if cookie.name == "refreshToken" {
//                                    KeychainManager.createToken(key: "refreshToken", token: "Bearer " + cookie.value)
//                                    HTTPCookieStorage.shared.setCookie(cookie)
//                                }
                            }
//                                print("------------------------------------")
                            self.parseQuery(intraId: String(query![0]), agreement: String(query![1]))
                            self.parent.isPresented = false
                        }
                    }
                }
            }
        }
        
        func parseQuery(intraId: String, agreement: String) {
//            print(intraId.components(separatedBy: "=")[1])
//            print(agreement.components(separatedBy: "=")[1])
            
            API.sharedAPI.intraId = Int(intraId.components(separatedBy: "=")[1])!
            
            if agreement.components(separatedBy: "=")[1] == "false" {
                parent.loginViewModel.isShowAgreementSheet = true
            } else {
                parent.homeViewModel.isAPILoaded = false
                parent.mainViewModel.isLogin = true
            }
            print("-------------- Parse --------------")
            print(KeychainManager.readToken(key: "accessToken") as Any)
            print(KeychainManager.readToken(key: "intraId") as Any)
//            print(KeychainManager.readToken(key: "refreshToken") as Any)
            print("------------------------------------")
        }
        
        func printError(message: String) {
            print(message)
            parent.mainViewModel.toast = Toast(title: "잠시 후 다시 시도해 주세요")
            parent.isPresented = false
            parent.mainViewModel.isLogin = false
        }
    }
}

#Preview {
    MyWebView(urlToLoad: "http://13.209.149.15:8080/v3/member?intraId=7", isPresented: .constant(true))
        .environmentObject(HomeViewModel())
        .environmentObject(MainViewModel())
        .environmentObject(LoginViewModel())
}

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
    }
    
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct MyWebView: UIViewRepresentable {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @AppStorage("accessToken") var accessToken = ""
    @AppStorage("refreshToken") var refreshToken = ""
    @AppStorage("isLogin") var isLogin = false
    
    var urlToLoad: String
    
    @Binding var isPresented: Bool
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: urlToLoad) else {
            return FullScreenWKWebView()
        }
        
        DispatchQueue.main.async {
            self.homeViewModel.isAPILoaded = false
        }
        
//        if homeViewModel.isLogout == true {
//            let webSiteDataTypes = NSSet(array: [WKWebsiteDataTypeCookies])
//            let date = NSDate(timeIntervalSince1970: 0)
//            WKWebsiteDataStore.default().removeData(ofTypes: webSiteDataTypes as! Set, modifiedSince: date as Date, completionHandler: {})
//        }
        
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
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            if let host = webView.url?.host() {
                print(host)
                if host == "localhost" {
//                    print(webView.url?.query()?.split(separator: "&"))
                    let query = webView.url?.query()?.split(separator: "&")
                    webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                        print("-------------- Cookie --------------")
                        for cookie in cookies {
//                            print(cookie.name, cookie.value)
                            if cookie.name == "accessToken" {
                                self.parent.accessToken = "Bearer " + cookie.value
                            } else if cookie.name == "refreshToken" {
                                self.parent.refreshToken = cookie.value
                            }
                        }
                        print("------------------------------------")
                        self.parseQuery(intraId: String(query![0]), agreement: String(query![1]))
                        self.parent.isPresented = false
                        self.parent.homeViewModel.getMemberInfo()
                        self.parent.homeViewModel.getGroup()
                    }
                }
            }
        }
        
        func parseQuery(intraId: String, agreement: String) {
//            print(intraId.components(separatedBy: "=")[1])
//            print(agreement.components(separatedBy: "=")[1])
            
            parent.homeViewModel.intraId = Int(intraId.components(separatedBy: "=")[1])!
            
            if agreement.components(separatedBy: "=")[1] == "false" {
                parent.homeViewModel.isShowAgreementSheet = true
            } else {
                parent.homeViewModel.isAPILoaded = false
                parent.isLogin = true
                parent.homeViewModel.isLogout = false
            }
//            print("-------------- Parse --------------")
//            print(parent.accessToken)
//            print(parent.refreshToken)
//            print("------------------------------------")
        }
    }
}

#Preview {
    MyWebView(urlToLoad: "http://13.209.149.15:8080/v3/member?intraId=7", isPresented: .constant(true))
        .environmentObject(MainViewModel())
}

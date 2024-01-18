//
//  MyWebView.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI
import WebKit

class FullScreenWKWebView: WKWebView {
    override var safeAreaInsets: UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

struct MyWebView: UIViewRepresentable {
    @EnvironmentObject private var mainViewModel: MainViewModel
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @AppStorage("token") var token = ""
    @AppStorage("isLogin") var isLogin = false
    
    var urlToLoad: String
    
    @Binding var isPresented: Bool
    
    func makeUIView(context: Context) -> some UIView {
        guard let url = URL(string: urlToLoad) else {
            return FullScreenWKWebView()
        }
        
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
        
        if homeViewModel.isLogout == true {
            let webSiteDataTypes = NSSet(array: [WKWebsiteDataTypeCookies])
            let date = NSDate(timeIntervalSince1970: 0)
            WKWebsiteDataStore.default().removeData(ofTypes: webSiteDataTypes as! Set, modifiedSince: date as Date, completionHandler: {})
        }
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
            print("didFinish")
            if let host = webView.url?.host() {
                print(host)
                if host == "localhost" {
//                    print(webView.url?.query()?.split(separator: "&"))
                    let query = webView.url?.query()?.split(separator: "&")
                    parseQuery(token: String(query![0]), intraId: String(query![1]), agreement: String(query![2]))
                    parent.isPresented = false
//                webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
//                    for cookie in cookies {
//                        print(cookie.name)
//                    }
//                }
                }
            }
        }
        
        func parseQuery(token: String, intraId: String, agreement: String) {
            print(token.components(separatedBy: "=")[1])
            print(intraId.components(separatedBy: "=")[1])
//            print(agreement.components(separatedBy: "=")[1])
            
            parent.homeViewModel.intraId = Int(intraId.components(separatedBy: "=")[1])!
//            parent.homeViewModel.intraId = 6
            parent.token = "Bearer " + token.components(separatedBy: "=")[1]
            if agreement.components(separatedBy: "=")[1] == "false" {
                parent.homeViewModel.isShowAgreementSheet = true
            } else {
                parent.homeViewModel.isAPILoaded = false
                parent.isLogin = true
                parent.homeViewModel.isLogout = false
            }
        }
    }
}

#Preview {
    MyWebView(urlToLoad: "http://13.209.149.15:8080/v3/member?intraId=7", isPresented: .constant(true))
        .environmentObject(MainViewModel())
}

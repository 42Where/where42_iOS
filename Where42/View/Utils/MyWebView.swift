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
            if let currentURL = webView.url?.absoluteString {
//                if currentURL == "https://intra.42.fr" {
//                parent.isPresented = false
                webView.configuration.websiteDataStore.httpCookieStore.getAllCookies { cookies in
                    for cookie in cookies {
                        if cookie.name == "where42" {
                            print(cookie.name)
                        }
                    }
//                    }
                }
            }
        }
    }
}

#Preview {
//    MyWebView(urlToLoad: "https://intra.42.fr", isPresented: .constant(true))
    MyWebView(urlToLoad: "https://github.com", isPresented: .constant(true))
        .environmentObject(MainViewModel())
}

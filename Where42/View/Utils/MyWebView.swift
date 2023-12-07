//
//  MyWebView.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SwiftUI
import WebKit

struct MyWebView: UIViewRepresentable {
    var urlToLoad: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: urlToLoad) else {
            return WKWebView()
        }

        let webView = WKWebView()

        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: UIViewRepresentableContext<MyWebView>) {}
}

#Preview {
    MyWebView(urlToLoad: "https://naver.com")
}

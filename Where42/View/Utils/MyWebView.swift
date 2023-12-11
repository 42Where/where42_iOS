//
//  MyWebView.swift
//  Where42
//
//  Created by 현동호 on 11/13/23.
//

import SafariServices
import SwiftUI

struct MyWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

#Preview {
    MyWebView(url: URL(string: "https://intra.42.fr")!)
}

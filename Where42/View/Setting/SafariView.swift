//
//  UseGuideSafariView.swift
//  Where42
//
//  Created by 현동호 on 4/5/24.
//

import SafariServices
import SwiftUI

struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> some UIViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
